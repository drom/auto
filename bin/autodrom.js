#!/usr/bin/env node
'use strict';

const process = require('process');
const path = require('path');
const { readFile, writeFile, stat } = require('fs/promises');
const { setTimeout } = require('timers/promises');

const { program } = require('commander');
const chokidar = require('chokidar');
const hpccwasm = require('@hpcc-js/wasm');

const lib = require('../lib/');

const readModifyWrite = async (filename, opts, graphviz, timeout) => {
  const src = await readFile(filename, {encoding: 'utf8'});
  const cells = lib.parse(src);
  lib.update(cells);

  const dst = cells.map(cell =>
    (cell.kind === 'meta')
      ? '/*' + cell.src + '*/'
      : cell.src
  ).join('');

  if (opts.svg) {
    const svgs = lib.extractSVG(graphviz, cells);
    for (let i = 0; i < svgs.length; i++) {
      await writeFile(filename + i + '.svg', svgs[i]);
    }
  }

  // console.log(filename, cells);

  await setTimeout(timeout);
  await writeFile(filename, dst);
};

const main = async () => {
  const graphviz = await hpccwasm.graphvizSync();

  program
    .option('-w, --watch', 'keep watching')
    .option('-s. --svg', 'generate SVG files')
    .parse(process.argv);

  const opts = program.opts();

  const watcher = chokidar.watch(program.args, {
    ignored: /(^|[/\\])\../, // ignore dotfiles
    persistent: true
  });

  if (opts.watch) {
    watcher.on('change', async (filename) => {
      console.log(`File ${filename} changed`);
      await watcher.unwatch(filename);
      await readModifyWrite(filename, opts, graphviz, 100);
      watcher.add(filename);
    });
  } else {
    await setTimeout(100);
    const watchedPaths = watcher.getWatched();
    watcher.close();
    const paths = Object.keys(watchedPaths);
    for (const pathKey of paths) {
      const points = watchedPaths[pathKey];
      for (const point of points) {
        const filename = path.resolve(pathKey, point);
        if ((await stat(filename)).isFile()) {
          console.log(filename);
          await readModifyWrite(filename, opts, graphviz, 10);
        }
      }
    }
  }
};

main();
