'use strict';

const _ = require('lodash');
const fsm = require('@wavedrom/fsm');
const myRequire = require('./my-require');
const vdim = require('./verilog-dim.js');

const vdir = (w) => {
  if (typeof w === 'string') {
    w = (w[0] === '-') ? -1 : 1;
  }
  return (w > 0) ? '  input ' : '  output';
};

function vio () {
  let ports = [];
  for (const arg of arguments) {
    if (Array.isArray(arg)) {
      ports = ports.concat(arg);
    } else {
      if (typeof arg === 'object') {
        ports = ports.concat(
          Object.keys(arg).map(key => ({n: key, v: arg[key]}))
        );
      }
    }
  }
  return ports.map(port => vdir(port.v) + vdim(port.v) + ' ' + port.n).join(',\n');
}

function reqack () {
  const res = [];
  for (const arg of arguments) {
    let [ts, is] = arg;
    if (!Array.isArray(ts)) {
      ts = [ts];
    }
    if (!Array.isArray(is)) {
      is = [is];
    }
    if ((ts.length === 1) & (is.length > 1)) {
      const t = ts[0];
      res.push(
        `// fork: ${is.length}`,
        `reg ${is.map(i => `${i}_reg`).join(', ')};`,
        ...is.map(i => `assign ${i}_req = ${t}_req & ~${i}_reg;`),
        ...is.map(i => `wire ${i}_ackg = ${i}_ack | ~${i}_req;`),
        `assign ${t}_ack = ${is.map(i => `${i}_ackg`).join(' & ')};`,
        ...is.map(i => `always @(posedge clock or negedge reset_n) if (~reset_n) ${i}_reg <= 1'b0; else ${i}_reg <= ${i}_ackg & ~${t}_ack;`)
      );
    } else if ((ts.length > 1) & (is.length === 1)) {
      const i = is[0];
      res.push(
        `// join: ${ts.length}`,
        `assign ${i}_req = ${ts.map(t => `${t}_req`).join(' & ')};`,
        ...ts.map((t, ti) =>
          `assign ${t}_ack = ${ts.map((te, tj) =>
            (ti === tj) ? i + '_ack' : te + '_req').join(' & ')};`)
      );
    }
  }
  return res.join('\n');
}

const update = (cells) => {
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind === 'meta') {
      let res;
      try { /* eslint no-new-func: 1 */
        res = new Function(`'use strict'; return (function (lib) { const {fsm, vio, reqack, fin, range, _, $, require} = lib; return (${cell.src}); })`)()({
          fsm: fsm.emit.verilog,
          reqack,
          vio,
          fin: undefined,
          range: _.range,
          _,
          require: myRequire,
          $
        });
      } catch (err) {
        // res = '// ' + err.message;
        console.log(err);
      }
      // if (Array.isArray(res)) {
      //   res = res.join('\n');
      // }
      if (typeof res === 'string') {
        // const cell1 = cells[i + 1];
        const cell2 = cells[i + 2];
        const guardRes = (
          '\n// ***** THIS TEXT IS AUTOMATICALLY GENERATED, DO NOT EDIT *****\n' +
          res +
          '\n// ***** END OF AUTOMATICALLY GENERATED TEXT, DO NOT EDIT *****\n'
        );
        if (cell2 && cell2.kind === 'meta' && cell2.src.trim() === 'fin') {
          cells[i + 1] = {kind: 'body', src: guardRes};
        } else {
          cells.splice(i + 1, 0, {kind: 'body', src: guardRes + '/* fin */'});
        }
      }
    }
  }
};

module.exports = update;
