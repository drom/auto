'use strict';

const multiBitFmt = (w) => ('[' + w + ':0]').padStart(14);

module.exports = w => {
  if (typeof w === 'number') {
    w = Math.abs(w);
    return (w === 1) ? '              ' : multiBitFmt(w - 1);
  }
  if (typeof w === 'string') {
    w = (w[0] === '-') ? w.slice(1) : w;
    w = w + '-1';
    return multiBitFmt(w);
  }
  throw new Error();

};
