'use strict';

const fsmDot = require('./fsm-dot.js');
const fsmVerilog = require('./fsm-verilog.js');
const parse = require('./parse.js');

exports.parse = parse;
exports.fsm = {
  dot: fsmDot,
  verilog: fsmVerilog
};
