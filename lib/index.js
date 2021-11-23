'use strict';

const fsmDot = require('./fsm-dot.js');
const fsmVerilog = require('./fsm-verilog.js');

exports.fsm = {
  dot: fsmDot,
  verilog: fsmVerilog
};
