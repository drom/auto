module jtag (
  input tck, tms, treset,
  output [3:0] outState
);

/* fsm({
  name: 'J',
  cond: 'tms',
  clock: 'tck',
  syncReset: 'treset',
  states: [
    // skewers
    {name: 'testLogicReset', next: {runTest: 0}},
    {name: 'runTest'},

    {name: 'selectDR',  next: {captureDR: 0}},
    {name: 'captureDR', next: {shiftDR:   0}},
    {name: 'shiftDR',   next: {exit1DR:   1}},
    {name: 'exit1DR',   next: {pauseDR:   0}},
    {name: 'pauseDR',   next: {exit2DR:   1}},
    {name: 'exit2DR',   next: {updateDR:  1}},
    'updateDR',

    {name: 'selectIR',  next: {captureIR: 0}},
    {name: 'captureIR', next: {shiftIR:   0}},
    {name: 'shiftIR',   next: {exit1IR:   1}},
    {name: 'exit1IR',   next: {pauseIR:   0}},
    {name: 'pauseIR',   next: {exit2IR:   1}},
    {name: 'exit2IR',   next: {updateIR:  1}},
    'updateIR',

    // bridge
    {name: 'runTest',   next: {selectDR:       1}},
    {name: 'selectDR',  next: {selectIR:       1}},
    {name: 'selectIR',  next: {testLogicReset: 1}},

    // DR
    {name: 'captureDR', next: {exit1DR:  1}},
    {name: 'exit1DR',   next: {updateDR: 1}},
    {name: 'exit2DR',   next: {shiftDR:  0}},
    {name: 'updateDR',  next: {runTest:  0, selectDR: 1}},

    // IR
    {name: 'captureIR', next: {exit1IR:  1}},
    {name: 'exit1IR',   next: {updateIR: 1}},
    {name: 'exit2IR',   next: {shiftIR:  0}},
    {name: 'updateIR',  next: {runTest: 0, selectIR: 1}}
  ]
}) */
// ***** THIS TEXT IS AUTOMATICALY GENERATED, DO NOT EDIT *****
reg [3:0] J_state, J_next;



// J state enums
wire [3:0] J_testLogicReset = 0;
wire [3:0] J_runTest        = 1;
wire [3:0] J_selectDR       = 2;
wire [3:0] J_captureDR      = 3;
wire [3:0] J_shiftDR        = 4;
wire [3:0] J_exit1DR        = 5;
wire [3:0] J_pauseDR        = 6;
wire [3:0] J_exit2DR        = 7;
wire [3:0] J_updateDR       = 8;
wire [3:0] J_selectIR       = 9;
wire [3:0] J_captureIR      = 10;
wire [3:0] J_shiftIR        = 11;
wire [3:0] J_exit1IR        = 12;
wire [3:0] J_pauseIR        = 13;
wire [3:0] J_exit2IR        = 14;
wire [3:0] J_updateIR       = 15;

// J transition conditions
wire J_testLogicReset_runTest  = ((J_state == J_testLogicReset) & (0 == tms));
wire J_runTest_selectDR        = ((J_state == J_runTest       ) & (1 == tms));
wire J_selectDR_captureDR      = ((J_state == J_selectDR      ) & (0 == tms));
wire J_selectDR_selectIR       = ((J_state == J_selectDR      ) & (1 == tms));
wire J_captureDR_shiftDR       = ((J_state == J_captureDR     ) & (0 == tms));
wire J_captureDR_exit1DR       = ((J_state == J_captureDR     ) & (1 == tms));
wire J_shiftDR_exit1DR         = ((J_state == J_shiftDR       ) & (1 == tms));
wire J_exit1DR_pauseDR         = ((J_state == J_exit1DR       ) & (0 == tms));
wire J_exit1DR_updateDR        = ((J_state == J_exit1DR       ) & (1 == tms));
wire J_pauseDR_exit2DR         = ((J_state == J_pauseDR       ) & (1 == tms));
wire J_exit2DR_updateDR        = ((J_state == J_exit2DR       ) & (1 == tms));
wire J_exit2DR_shiftDR         = ((J_state == J_exit2DR       ) & (0 == tms));
wire J_updateDR_runTest        = ((J_state == J_updateDR      ) & (0 == tms));
wire J_updateDR_selectDR       = ((J_state == J_updateDR      ) & (1 == tms));
wire J_selectIR_captureIR      = ((J_state == J_selectIR      ) & (0 == tms));
wire J_selectIR_testLogicReset = ((J_state == J_selectIR      ) & (1 == tms));
wire J_captureIR_shiftIR       = ((J_state == J_captureIR     ) & (0 == tms));
wire J_captureIR_exit1IR       = ((J_state == J_captureIR     ) & (1 == tms));
wire J_shiftIR_exit1IR         = ((J_state == J_shiftIR       ) & (1 == tms));
wire J_exit1IR_pauseIR         = ((J_state == J_exit1IR       ) & (0 == tms));
wire J_exit1IR_updateIR        = ((J_state == J_exit1IR       ) & (1 == tms));
wire J_pauseIR_exit2IR         = ((J_state == J_pauseIR       ) & (1 == tms));
wire J_exit2IR_updateIR        = ((J_state == J_exit2IR       ) & (1 == tms));
wire J_exit2IR_shiftIR         = ((J_state == J_exit2IR       ) & (0 == tms));
wire J_updateIR_runTest        = ((J_state == J_updateIR      ) & (0 == tms));
wire J_updateIR_selectIR       = ((J_state == J_updateIR      ) & (1 == tms));

// J state enter conditions
wire J_runTest_onEnter        = (J_testLogicReset_runTest | J_updateDR_runTest | J_updateIR_runTest);
wire J_selectDR_onEnter       = (J_runTest_selectDR | J_updateDR_selectDR);
wire J_captureDR_onEnter      = (J_selectDR_captureDR);
wire J_selectIR_onEnter       = (J_selectDR_selectIR | J_updateIR_selectIR);
wire J_shiftDR_onEnter        = (J_captureDR_shiftDR | J_exit2DR_shiftDR);
wire J_exit1DR_onEnter        = (J_captureDR_exit1DR | J_shiftDR_exit1DR);
wire J_pauseDR_onEnter        = (J_exit1DR_pauseDR);
wire J_updateDR_onEnter       = (J_exit1DR_updateDR | J_exit2DR_updateDR);
wire J_exit2DR_onEnter        = (J_pauseDR_exit2DR);
wire J_captureIR_onEnter      = (J_selectIR_captureIR);
wire J_testLogicReset_onEnter = (J_selectIR_testLogicReset);
wire J_shiftIR_onEnter        = (J_captureIR_shiftIR | J_exit2IR_shiftIR);
wire J_exit1IR_onEnter        = (J_captureIR_exit1IR | J_shiftIR_exit1IR);
wire J_pauseIR_onEnter        = (J_exit1IR_pauseIR);
wire J_updateIR_onEnter       = (J_exit1IR_updateIR | J_exit2IR_updateIR);
wire J_exit2IR_onEnter        = (J_pauseIR_exit2IR);
// J state exit conditions
wire J_testLogicReset_onExit  = (J_testLogicReset_runTest);
wire J_runTest_onExit         = (J_runTest_selectDR);
wire J_selectDR_onExit        = (J_selectDR_captureDR | J_selectDR_selectIR);
wire J_captureDR_onExit       = (J_captureDR_shiftDR | J_captureDR_exit1DR);
wire J_shiftDR_onExit         = (J_shiftDR_exit1DR);
wire J_exit1DR_onExit         = (J_exit1DR_pauseDR | J_exit1DR_updateDR);
wire J_pauseDR_onExit         = (J_pauseDR_exit2DR);
wire J_exit2DR_onExit         = (J_exit2DR_updateDR | J_exit2DR_shiftDR);
wire J_updateDR_onExit        = (J_updateDR_runTest | J_updateDR_selectDR);
wire J_selectIR_onExit        = (J_selectIR_captureIR | J_selectIR_testLogicReset);
wire J_captureIR_onExit       = (J_captureIR_shiftIR | J_captureIR_exit1IR);
wire J_shiftIR_onExit         = (J_shiftIR_exit1IR);
wire J_exit1IR_onExit         = (J_exit1IR_pauseIR | J_exit1IR_updateIR);
wire J_pauseIR_onExit         = (J_pauseIR_exit2IR);
wire J_exit2IR_onExit         = (J_exit2IR_updateIR | J_exit2IR_shiftIR);
wire J_updateIR_onExit        = (J_updateIR_runTest | J_updateIR_selectIR);

// J next state select
always @(*) begin : J_next_select
  case (1'b1)
    J_testLogicReset_runTest  : J_next = J_runTest;
    J_runTest_selectDR        : J_next = J_selectDR;
    J_selectDR_captureDR      : J_next = J_captureDR;
    J_selectDR_selectIR       : J_next = J_selectIR;
    J_captureDR_shiftDR       : J_next = J_shiftDR;
    J_captureDR_exit1DR       : J_next = J_exit1DR;
    J_shiftDR_exit1DR         : J_next = J_exit1DR;
    J_exit1DR_pauseDR         : J_next = J_pauseDR;
    J_exit1DR_updateDR        : J_next = J_updateDR;
    J_pauseDR_exit2DR         : J_next = J_exit2DR;
    J_exit2DR_updateDR        : J_next = J_updateDR;
    J_exit2DR_shiftDR         : J_next = J_shiftDR;
    J_updateDR_runTest        : J_next = J_runTest;
    J_updateDR_selectDR       : J_next = J_selectDR;
    J_selectIR_captureIR      : J_next = J_captureIR;
    J_selectIR_testLogicReset : J_next = J_testLogicReset;
    J_captureIR_shiftIR       : J_next = J_shiftIR;
    J_captureIR_exit1IR       : J_next = J_exit1IR;
    J_shiftIR_exit1IR         : J_next = J_exit1IR;
    J_exit1IR_pauseIR         : J_next = J_pauseIR;
    J_exit1IR_updateIR        : J_next = J_updateIR;
    J_pauseIR_exit2IR         : J_next = J_exit2IR;
    J_exit2IR_updateIR        : J_next = J_updateIR;
    J_exit2IR_shiftIR         : J_next = J_shiftIR;
    J_updateIR_runTest        : J_next = J_runTest;
    J_updateIR_selectIR       : J_next = J_selectIR;
    default                   : J_next = J_state;
  endcase
end

always @(posedge tck)
  if (treset) J_state <= J_testLogicReset;
  else        J_state <= J_next;

// ***** END OF AUTOMATICALY GENERATED TEXT, DO NOT EDIT *****
/* fin */

assign outState = J_state;

endmodule
