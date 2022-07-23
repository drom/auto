'use strict';

const range = require('lodash.range');
const fsm = require('@wavedrom/fsm');
const myRequire = require('./my-require');

const update = (cells) => {
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind === 'meta') {
      let res;
      try { /* eslint no-new-func: 1 */
        res = new Function(`'use strict'; return (function (lib) { const {fsm, fin, range, $, require} = lib; return (${cell.src}); })`)()({
          fsm: fsm.emit.verilog,
          fin: undefined,
          range,
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
