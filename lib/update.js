'use strict';

const range = require('lodash.range');
const fsm = require('@wavedrom/fsm');

const update = (cells) => {
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind === 'meta') {
      let res;
      try { /* eslint no-new-func: 1 */
        res = new Function(`
'use strict';
return (function (lib) {
  const {fsm, fin, range, $} = lib;
  return (${cell.src});
})`)()({
          fsm: fsm.emit.verilog,
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
        // const cell1 = cells[i + 1];
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

module.exports = update;
