module quadrature (
  input clk, reset_n, a, b,
  output err,
  output reg [7:0] counter
);

/* fsm({
  clock: 'clk',
  asyncReset: '~reset_n',
  condition: '{a, b}',
  draw: 'dot', // circo, dot
  ascii: true,
  states: {
    start: {s00: "2'b00", s01: "2'b01", s11: "2'b11", s10: "2'b10"},
    s00:   {s01: "2'b01", s10: "2'b10", error: "2'b11"},
    s01:   {s11: "2'b11", s00: "2'b00", error: "2'b10"},
    s11:   {s10: "2'b10", s01: "2'b01", error: "2'b00"},
    s10:   {s00: "2'b00", s11: "2'b11", error: "2'b01"},
    error: {}
  }
}) */
// ***** THIS TEXT IS AUTOMATICALLY GENERATED, DO NOT EDIT *****
reg [2:0] FSM_state, FSM_next;



// FSM state enums
wire [2:0] FSM_start = 0;
wire [2:0] FSM_s00   = 1;
wire [2:0] FSM_s01   = 2;
wire [2:0] FSM_s11   = 3;
wire [2:0] FSM_s10   = 4;
wire [2:0] FSM_error = 5;

// FSM transition conditions
wire FSM_start_s00 = ((FSM_state == FSM_start) & (2'b00 == {a, b}));
wire FSM_start_s01 = ((FSM_state == FSM_start) & (2'b01 == {a, b}));
wire FSM_start_s11 = ((FSM_state == FSM_start) & (2'b11 == {a, b}));
wire FSM_start_s10 = ((FSM_state == FSM_start) & (2'b10 == {a, b}));
wire FSM_s00_s01   = ((FSM_state == FSM_s00  ) & (2'b01 == {a, b}));
wire FSM_s00_s10   = ((FSM_state == FSM_s00  ) & (2'b10 == {a, b}));
wire FSM_s00_error = ((FSM_state == FSM_s00  ) & (2'b11 == {a, b}));
wire FSM_s01_s11   = ((FSM_state == FSM_s01  ) & (2'b11 == {a, b}));
wire FSM_s01_s00   = ((FSM_state == FSM_s01  ) & (2'b00 == {a, b}));
wire FSM_s01_error = ((FSM_state == FSM_s01  ) & (2'b10 == {a, b}));
wire FSM_s11_s10   = ((FSM_state == FSM_s11  ) & (2'b10 == {a, b}));
wire FSM_s11_s01   = ((FSM_state == FSM_s11  ) & (2'b01 == {a, b}));
wire FSM_s11_error = ((FSM_state == FSM_s11  ) & (2'b00 == {a, b}));
wire FSM_s10_s00   = ((FSM_state == FSM_s10  ) & (2'b00 == {a, b}));
wire FSM_s10_s11   = ((FSM_state == FSM_s10  ) & (2'b11 == {a, b}));
wire FSM_s10_error = ((FSM_state == FSM_s10  ) & (2'b01 == {a, b}));

// FSM state entry conditions
wire FSM_s00_onEntry   = (FSM_start_s00 | FSM_s01_s00 | FSM_s10_s00);
wire FSM_s01_onEntry   = (FSM_start_s01 | FSM_s00_s01 | FSM_s11_s01);
wire FSM_s11_onEntry   = (FSM_start_s11 | FSM_s01_s11 | FSM_s10_s11);
wire FSM_s10_onEntry   = (FSM_start_s10 | FSM_s00_s10 | FSM_s11_s10);
wire FSM_error_onEntry = (FSM_s00_error | FSM_s01_error | FSM_s11_error | FSM_s10_error);

// FSM state exit conditions
wire FSM_start_onExit  = (FSM_start_s00 | FSM_start_s01 | FSM_start_s11 | FSM_start_s10);
wire FSM_s00_onExit    = (FSM_s00_s01 | FSM_s00_s10 | FSM_s00_error);
wire FSM_s01_onExit    = (FSM_s01_s11 | FSM_s01_s00 | FSM_s01_error);
wire FSM_s11_onExit    = (FSM_s11_s10 | FSM_s11_s01 | FSM_s11_error);
wire FSM_s10_onExit    = (FSM_s10_s00 | FSM_s10_s11 | FSM_s10_error);
// FSM_error state has no exit

// FSM state self conditions
wire FSM_start_onSelf  = (FSM_state == FSM_start) & ~FSM_start_onExit;
wire FSM_s00_onSelf    = (FSM_state == FSM_s00  ) & ~FSM_s00_onExit;
wire FSM_s01_onSelf    = (FSM_state == FSM_s01  ) & ~FSM_s01_onExit;
wire FSM_s11_onSelf    = (FSM_state == FSM_s11  ) & ~FSM_s11_onExit;
wire FSM_s10_onSelf    = (FSM_state == FSM_s10  ) & ~FSM_s10_onExit;
wire FSM_error_onSelf  = (FSM_state == FSM_error) & ~FSM_error_onExit;

// FSM next state select
always @(*) begin : FSM_next_select
  case (1'b1)
    FSM_start_s00 : FSM_next = FSM_s00;
    FSM_start_s01 : FSM_next = FSM_s01;
    FSM_start_s11 : FSM_next = FSM_s11;
    FSM_start_s10 : FSM_next = FSM_s10;
    FSM_s00_s01   : FSM_next = FSM_s01;
    FSM_s00_s10   : FSM_next = FSM_s10;
    FSM_s00_error : FSM_next = FSM_error;
    FSM_s01_s11   : FSM_next = FSM_s11;
    FSM_s01_s00   : FSM_next = FSM_s00;
    FSM_s01_error : FSM_next = FSM_error;
    FSM_s11_s10   : FSM_next = FSM_s10;
    FSM_s11_s01   : FSM_next = FSM_s01;
    FSM_s11_error : FSM_next = FSM_error;
    FSM_s10_s00   : FSM_next = FSM_s00;
    FSM_s10_s11   : FSM_next = FSM_s11;
    FSM_s10_error : FSM_next = FSM_error;
    default       : FSM_next = FSM_state;
  endcase
end

always @(posedge clk or negedge reset_n)
  if (~reset_n) FSM_state <= FSM_start;
  else          FSM_state <= FSM_next;

reg [39:0] FSM_state_ascii;
always @(*)
  case ({FSM_state})
    FSM_start : FSM_state_ascii = "start";
    FSM_s00   : FSM_state_ascii = "s00  ";
    FSM_s01   : FSM_state_ascii = "s01  ";
    FSM_s11   : FSM_state_ascii = "s11  ";
    FSM_s10   : FSM_state_ascii = "s10  ";
    FSM_error : FSM_state_ascii = "error";
    default   : FSM_state_ascii = "%Erro";
  endcase

// ***** END OF AUTOMATICALLY GENERATED TEXT, DO NOT EDIT *****
/* fin */

always @(posedge clk or negedge reset_n)
  if (~reset_n) counter <= 'b0;
  else
    if (FSM_s00_s01 | FSM_s01_s11 | FSM_s11_s10 | FSM_s10_s00)
      counter <= counter + 1;
    else if (FSM_s00_s10 | FSM_s10_s11 | FSM_s11_s01 | FSM_s01_s00)
      counter <= counter - 1;

assign err = FSM_state == FSM_error;

endmodule
