'use strict';

const path = require('path');
const range = require('lodash.range');
const fsm = require('@wavedrom/fsm');

const update = (cells, filename) => {
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind === 'meta') {
      let res;
      try { /* eslint no-new-func: 1 */
        res = new Function(`
'use strict';
return (function (lib) {
  const {fsm, fin, range, $, require} = lib;
  return (${cell.src});
})`)()({
          fsm: fsm.emit.verilog,
          fin: undefined,
          range,
          $,
          require: (pat) => require(path.join(path.dirname(filename), pat))
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
        if (cell2 && cell2.kind === 'meta' && cell2.src.trim() === 'fin') {
          cells[i + 1] = {kind: 'body', src: res};
        } else {
          cells.splice(i + 1, 0, {kind: 'body', src: res + '/* fin */'});
        }
      }
    }
  }
};

module.exports = update;
