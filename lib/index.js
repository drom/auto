'use strict';

const parse = require('./parse.js');
const update = require('./update.js');
const extractSVG = require('./extract-svg.js');
const myRequire = require('./my-require.js');

exports.parse = parse;
exports.update = update;
exports.extractSVG = extractSVG;
exports.require = myRequire;
