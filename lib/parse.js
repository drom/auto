'use strict';

const parse = (src) => {
  const cells = [];
  let str = src;
  while (true) {
    const idx0 = str.search(/\/\*/);
    if (idx0 === -1) {
      cells.push({kind: 'body', src: str});
      break;
    }
    if (idx0 > 0) {
      const chunk = str.slice(0, idx0);
      cells.push({kind: 'body', src: chunk});
    }
    str = str.slice(idx0 + 2);
    const idx1 = str.search(/\*\//);
    if (idx1 === -1) {
      (cells[cells.length - 1]).body += '/*' + str;
      break;
    }
    if (idx1 > 0) {
      const chunk = str.slice(0, idx1);
      cells.push({kind: 'meta', src: chunk});
    }
    str = str.slice(idx1 + 2);
  }
  return cells;
};

module.exports = parse;
