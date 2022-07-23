'use strict';
const path = require('path');

module.exports = str => {
  const fullPath = path.join(process.cwd(), str);
  // console.log(fullPath);
  const res = require(fullPath);
  // console.log(res);
  return res;
};
