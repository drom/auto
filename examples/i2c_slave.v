module i2c_slave (
  input ena, rw,
  input clock, rst
);

/* fsm({
  registers: {
    started: 1,
    bit_cnt: {width: 8, init: 8},
    phase: 2 // width
  },
  states: [{
    name: 'begin', style: 'filled,rounded', fillcolor: '#dddddd',
    next: [
      {name: 'ready', condition: "1'b1", actions: {started: "1'b1"}}
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
    onEntry: {
      bit_cnt: 8,
      phase: 1
    },
    next: [
      {name: 'slv_ack1', condition: 'bit_cnt == 0'},
      {name: 'command',  condition: 'bit_cnt != 0', actions: {bit_cnt: 'bit_cnt - 1'}}
    ]
  }, {
    name: 'slv_ack1',
    next: [
      {name: 'wr', condition: "rw == 0"},
      {name: 'rd', condition: "rw == 1"}
    ]
  }, {
    name: 'wr', onEntry: {phase: 2}, onExit: {phase: 42}
  }, {
    name: 'rd', onExit: {phase: 3}, onSelf: {phase: 33}
  }]
}) */
// ***** THIS TEXT IS AUTOMATICALLY GENERATED, DO NOT EDIT *****
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

// FSM state entry conditions
wire FSM_ready_onEntry    = (FSM_begin_ready);
wire FSM_start_onEntry    = (FSM_ready_start);
wire FSM_command_onEntry  = (FSM_start_command | FSM_command_command);
wire FSM_slv_ack1_onEntry = (FSM_command_slv_ack1);
wire FSM_wr_onEntry       = (FSM_slv_ack1_wr);
wire FSM_rd_onEntry       = (FSM_slv_ack1_rd);

// FSM state exit conditions
wire FSM_begin_onExit     = (FSM_begin_ready);
wire FSM_ready_onExit     = (FSM_ready_start);
wire FSM_start_onExit     = (FSM_start_command);
wire FSM_command_onExit   = (FSM_command_slv_ack1 | FSM_command_command);
wire FSM_slv_ack1_onExit  = (FSM_slv_ack1_wr | FSM_slv_ack1_rd);
// FSM_wr state has no exit
// FSM_rd state has no exit

// FSM state self conditions
wire FSM_begin_onSelf     = (FSM_state == FSM_begin   ) & ~FSM_begin_onExit;
wire FSM_ready_onSelf     = (FSM_state == FSM_ready   ) & ~FSM_ready_onExit;
wire FSM_start_onSelf     = (FSM_state == FSM_start   ) & ~FSM_start_onExit;
wire FSM_command_onSelf   = (FSM_state == FSM_command ) & ~FSM_command_onExit;
wire FSM_slv_ack1_onSelf  = (FSM_state == FSM_slv_ack1) & ~FSM_slv_ack1_onExit;
wire FSM_wr_onSelf        = (FSM_state == FSM_wr      ) & ~FSM_wr_onExit;
wire FSM_rd_onSelf        = (FSM_state == FSM_rd      ) & ~FSM_rd_onExit;

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
      FSM_command_onEntry : begin
        bit_cnt <= 8;
        phase <= 1;
      end
      FSM_wr_onEntry : begin
        phase <= 2;
      end
    endcase
    case (1'b1)
      FSM_wr_onExit : begin
        phase <= 42;
      end
      FSM_rd_onExit : begin
        phase <= 3;
      end
      FSM_rd_onSelf : begin
        phase <= 33;
      end
    endcase
  end

// ***** END OF AUTOMATICALLY GENERATED TEXT, DO NOT EDIT *****
/* fin */

endmodule
