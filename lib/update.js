'use strict';

const _ = require('lodash');
const fsm = require('@wavedrom/fsm');
const myRequire = require('./my-require');
const vdim = require('./verilog-dim.js');
const reqack = require('./reqack.js');

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

const padStart = (val, targetLength, padString) => {
  const str = val.toString();
  return str.padStart(targetLength, padString);
};

const padEnd = (val, targetLength, padString) => {
  const str = val.toString();
  return str.padEnd(targetLength, padString);
};

const update = (cells) => {
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind === 'meta') {
      let res;
      try { /* eslint no-new-func: 1 */
        res = new Function(
          '\'use strict\';'
          + ' return (function (lib) { const {'
          + 'fsm, vio, reqack, fin, range, padStart, padEnd, _, require, $'
          + '} = lib; return ('
          + cell.src
          + '); })'
        )()({
          fsm: fsm.emit.verilog,
          vio,
          reqack,
          fin: undefined,
          range: _.range,
          padStart,
          padEnd,
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
