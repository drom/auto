module i2c_slave (
  input ena, rw,
  input clock, rst
);

/* fsm({
  regs: {
    started: 1,
    bit_cnt: {width: 8, init: 8},
    phase: 2 // width
  },
  states: [{
    name: 'begin', style: 'filled,rounded', fillcolor: '#dddddd',
    next: [
      {name: 'ready', cond: "1'b1", actions: {started: "1'b1"}}
    ]
  }, {
    name: 'ready',
    next: {
      start: 'ena'
    }
  }, {
    name: 'start',
    next: {
      command: "1'b1"
    }
  }, {
    name: 'command',
    onEnter: {
      bit_cnt: 8,
      phase: 1
    },
    next: [
      {name: 'slv_ack1', cond: 'bit_cnt == 0'},
      {name: 'command',  cond: 'bit_cnt != 0', actions: {bit_cnt: 'bit_cnt - 1'}}
    ]
  }, {
    name: 'slv_ack1',
    next: [
      {name: 'wr', cond: "rw == 0"},
      {name: 'rd', cond: "rw == 1"}
    ]
  }, {
    name: 'wr', onEnter: {phase: 2}
  }, {
    name: 'rd', onEnter: {phase: 3}
  }]
}) */// ***** THIS TEXT IS AUTOMATICALY GENERATED, DO NOT EDIT *****
reg [2:0] FSM_state, FSM_next;
reg started;
reg [7:0] bit_cnt;
reg [1:0] phase;



// FSM state enums
wire [2:0] FSM_begin    = 0;
wire [2:0] FSM_ready    = 1;
wire [2:0] FSM_start    = 2;
wire [2:0] FSM_command  = 3;
wire [2:0] FSM_slv_ack1 = 4;
wire [2:0] FSM_wr       = 5;
wire [2:0] FSM_rd       = 6;

// FSM transition conditions
wire FSM_begin_ready      = ((FSM_state == FSM_begin   ) & (1'b1));
wire FSM_ready_start      = ((FSM_state == FSM_ready   ) & (ena));
wire FSM_start_command    = ((FSM_state == FSM_start   ) & (1'b1));
wire FSM_command_slv_ack1 = ((FSM_state == FSM_command ) & (bit_cnt == 0));
wire FSM_command_command  = ((FSM_state == FSM_command ) & (bit_cnt != 0));
wire FSM_slv_ack1_wr      = ((FSM_state == FSM_slv_ack1) & (rw == 0));
wire FSM_slv_ack1_rd      = ((FSM_state == FSM_slv_ack1) & (rw == 1));

// FSM state enter conditions
wire FSM_ready_onEnter    = (FSM_begin_ready);
wire FSM_start_onEnter    = (FSM_ready_start);
wire FSM_command_onEnter  = (FSM_start_command | FSM_command_command);
wire FSM_slv_ack1_onEnter = (FSM_command_slv_ack1);
wire FSM_wr_onEnter       = (FSM_slv_ack1_wr);
wire FSM_rd_onEnter       = (FSM_slv_ack1_rd);
// FSM state exit conditions
wire FSM_begin_onExit     = (FSM_begin_ready);
wire FSM_ready_onExit     = (FSM_ready_start);
wire FSM_start_onExit     = (FSM_start_command);
wire FSM_command_onExit   = (FSM_command_slv_ack1 | FSM_command_command);
wire FSM_slv_ack1_onExit  = (FSM_slv_ack1_wr | FSM_slv_ack1_rd);
// FSM_wr state has no exit
// FSM_rd state has no exit

// FSM next state select
always @(*) begin : FSM_next_select
  case (1'b1)
    FSM_begin_ready      : FSM_next = FSM_ready;
    FSM_ready_start      : FSM_next = FSM_start;
    FSM_start_command    : FSM_next = FSM_command;
    FSM_command_slv_ack1 : FSM_next = FSM_slv_ack1;
    FSM_command_command  : FSM_next = FSM_command;
    FSM_slv_ack1_wr      : FSM_next = FSM_wr;
    FSM_slv_ack1_rd      : FSM_next = FSM_rd;
    default              : FSM_next = FSM_state;
  endcase
end

always @(posedge clock)
  if (rst) FSM_state <= FSM_begin;
  else     FSM_state <= FSM_next;

// FSM actions
always @(posedge clock)
  if (rst) begin
    started <= 0;
    bit_cnt <= 8;
    phase <= 0;
  end else begin
    case (1'b1)
      FSM_begin_ready : begin
        started <= 1'b1;
      end
      FSM_command_command : begin
        bit_cnt <= bit_cnt - 1;
      end
    endcase
    case (1'b1)
      FSM_command_onEnter : begin
        bit_cnt <= 8;
        phase <= 1;
      end
      FSM_wr_onEnter : begin
        phase <= 2;
      end
      FSM_rd_onEnter : begin
        phase <= 3;
      end
    endcase
  end

// ***** END OF AUTOMATICALY GENERATED TEXT, DO NOT EDIT *****/* fin */

endmodule
