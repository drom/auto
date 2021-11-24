#!/usr/bin/env node
'use strict';

const process = require('process');
const path = require('path');
const { readFile, writeFile, stat } = require('fs/promises');
const { setTimeout } = require('timers/promises');
const lib = require('../lib/');
const range = require('lodash.range');
const { program } = require('commander');
const chokidar = require('chokidar');

const update = (cells) => {
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind === 'meta') {
      let res;
      try {
        res = new Function(`
'use strict';
return (function (lib) {
  const {fsm, fin, range, $} = lib;
  return (${cell.src});
})`)()({
          fsm: lib.fsm.verilog,
          fin: undefined,
          range: range,
          $
        });
      } catch (err) {
        // res = '// ' + err.message;
        console.log(err);
      }
      if (res !== undefined) {
        if (Array.isArray(res)) {
          res = res.join('\n');
        }
        const cell1 = cells[i + 1];
        const cell2 = cells[i + 2];
        if (cell2 && cell2.kind === 'meta' && cell2.src.trim() === 'fin') {
          cells[i + 1] = {kind: 'body', src: '\n' + res + '\n'};
        } else {
          cells.splice(i + 1, 0, {kind: 'body', src: '\n' + res + '\n/* fin */'});
        }
      }
    }
  }
};

const readModifyWrite = async (filename, timeout) => {
  const src = await readFile(filename, {encoding: 'utf8'});
  const cells = lib.parse(src);
  update(cells);
  const dst = cells.map(cell =>
    (cell.kind === 'meta')
      ? '/*' + cell.src + '*/'
      : cell.src
  ).join('');
  await setTimeout(timeout);
  await writeFile(filename, dst);
};

const main = async () => {
  program
    .option('-w, --watch', 'keep watching')
    .parse(process.argv);

  const opts = program.opts();

  const watcher = chokidar.watch(program.args, {
    ignored: /(^|[\/\\])\../, // ignore dotfiles
    persistent: true
  });

  if (opts.watch) {
    watcher.on('change', async (filename) => {
      console.log(`File ${filename} changed`);
      await watcher.unwatch(filename);
      await readModifyWrite(filename, 100);
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
          await readModifyWrite(filename, 10);
        }
      }
    }
  }
};

main();
