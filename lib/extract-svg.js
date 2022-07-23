'use strict';

const range = require('lodash.range');
const fsm = require('@wavedrom/fsm');
const myRequire = require('./my-require');

const extractSVG = (graphviz, cells) => {

  const fsmSvg = (desc) => {
    if (typeof desc !== 'object') {
      return;
    }
    const dot = fsm.emit.dot(desc);
    const draw = desc.draw || 'dot';
    const svg = graphviz.layout(dot, 'svg', draw);
    return svg;
  };

  const ret = [];
  const $ = {};
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell.kind !== 'meta') {
      continue;
    }
    let res;
    try { /* eslint no-new-func: 1 */
      res = new Function(`'use strict'; return (function (lib) { const {fsm, fin, range, require, $} = lib; return (${cell.src}); })`)()({
        fsm: fsmSvg,
        fin: undefined,
        range: range,
        require: myRequire,
        $
      });
    } catch (err) {
      // res = '// ' + err.message;
      console.log(err);
    }
    if (res !== undefined) {
      ret.push(res);
    }
  }
  return ret;
};

module.exports = extractSVG;
