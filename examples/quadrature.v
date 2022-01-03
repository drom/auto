module quadrature (
  input clk, reset_n, a, b,
  output err,
  output reg [7:0] counter
);

/* fsm({
  clock: 'clk',
  asyncReset: '~reset_n',
  cond: '{a, b}',
  draw: 'dot', // circo, dot
  ascii: true,
  states: {
    s00: {s01: "2'b01", s10: "2'b10", err: "2'b11"},
    s01: {s11: "2'b11", s00: "2'b00", err: "2'b10"},
    s11: {s10: "2'b10", s01: "2'b01", err: "2'b00"},
    s10: {s00: "2'b00", s11: "2'b11", err: "2'b01"},
    err: {}
  }
}) */
// ***** THIS TEXT IS AUTOMATICALY GENERATED, DO NOT EDIT *****
reg [2:0] FSM_state, FSM_next;



// FSM state enums
wire [2:0] FSM_s00 = 0;
wire [2:0] FSM_s01 = 1;
wire [2:0] FSM_s11 = 2;
wire [2:0] FSM_s10 = 3;
wire [2:0] FSM_err = 4;

// FSM transition conditions
wire FSM_s00_s01 = ((FSM_state == FSM_s00) & (2'b01 == {a, b}));
wire FSM_s00_s10 = ((FSM_state == FSM_s00) & (2'b10 == {a, b}));
wire FSM_s00_err = ((FSM_state == FSM_s00) & (2'b11 == {a, b}));
wire FSM_s01_s11 = ((FSM_state == FSM_s01) & (2'b11 == {a, b}));
wire FSM_s01_s00 = ((FSM_state == FSM_s01) & (2'b00 == {a, b}));
wire FSM_s01_err = ((FSM_state == FSM_s01) & (2'b10 == {a, b}));
wire FSM_s11_s10 = ((FSM_state == FSM_s11) & (2'b10 == {a, b}));
wire FSM_s11_s01 = ((FSM_state == FSM_s11) & (2'b01 == {a, b}));
wire FSM_s11_err = ((FSM_state == FSM_s11) & (2'b00 == {a, b}));
wire FSM_s10_s00 = ((FSM_state == FSM_s10) & (2'b00 == {a, b}));
wire FSM_s10_s11 = ((FSM_state == FSM_s10) & (2'b11 == {a, b}));
wire FSM_s10_err = ((FSM_state == FSM_s10) & (2'b01 == {a, b}));

// FSM state enter conditions
wire FSM_s01_onEnter = (FSM_s00_s01 | FSM_s11_s01);
wire FSM_s10_onEnter = (FSM_s00_s10 | FSM_s11_s10);
wire FSM_err_onEnter = (FSM_s00_err | FSM_s01_err | FSM_s11_err | FSM_s10_err);
wire FSM_s11_onEnter = (FSM_s01_s11 | FSM_s10_s11);
wire FSM_s00_onEnter = (FSM_s01_s00 | FSM_s10_s00);
// FSM state exit conditions
wire FSM_s00_onExit  = (FSM_s00_s01 | FSM_s00_s10 | FSM_s00_err);
wire FSM_s01_onExit  = (FSM_s01_s11 | FSM_s01_s00 | FSM_s01_err);
wire FSM_s11_onExit  = (FSM_s11_s10 | FSM_s11_s01 | FSM_s11_err);
wire FSM_s10_onExit  = (FSM_s10_s00 | FSM_s10_s11 | FSM_s10_err);
// FSM_err state has no exit

// FSM next state select
always @(*) begin : FSM_next_select
  case (1'b1)
    FSM_s00_s01 : FSM_next = FSM_s01;
    FSM_s00_s10 : FSM_next = FSM_s10;
    FSM_s00_err : FSM_next = FSM_err;
    FSM_s01_s11 : FSM_next = FSM_s11;
    FSM_s01_s00 : FSM_next = FSM_s00;
    FSM_s01_err : FSM_next = FSM_err;
    FSM_s11_s10 : FSM_next = FSM_s10;
    FSM_s11_s01 : FSM_next = FSM_s01;
    FSM_s11_err : FSM_next = FSM_err;
    FSM_s10_s00 : FSM_next = FSM_s00;
    FSM_s10_s11 : FSM_next = FSM_s11;
    FSM_s10_err : FSM_next = FSM_err;
    default     : FSM_next = FSM_state;
  endcase
end

always @(posedge clk or negedge reset_n)
  if (~reset_n) FSM_state <= FSM_s00;
  else          FSM_state <= FSM_next;

reg [23:0] FSM_state_ascii;
always @(*)
  case ({FSM_state})
    FSM_s00 : FSM_state_ascii = "s00";
    FSM_s01 : FSM_state_ascii = "s01";
    FSM_s11 : FSM_state_ascii = "s11";
    FSM_s10 : FSM_state_ascii = "s10";
    FSM_err : FSM_state_ascii = "err";
    default : FSM_state_ascii = "%Er";
  endcase

// ***** END OF AUTOMATICALY GENERATED TEXT, DO NOT EDIT *****
/* fin */

always @(posedge clk or negedge reset_n)
  if (~reset_n) counter <= 'b0;
  else
    if (FSM_s00_s01 | FSM_s01_s11 | FSM_s11_s10 | FSM_s10_s00)
      counter <= counter + 1;
    else if (FSM_s00_s10 | FSM_s10_s11 | FSM_s11_s01 | FSM_s01_s00)
      counter <= counter - 1;

assign err = FSM_state == FSM_err;

endmodule
