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
  states: [
    {name: 'zero_zero', next: {
      zero_one: "2'b01",
      one_zero: "2'b10"
    }}, // err: "2'b11"},
    {name: 'zero_one', next: {
      one_one: "2'b11",
      zero_zero: "2'b00"
    }}, // err: "2'b10"},
    {name: 'one_zero', next: {
      zero_zero: "2'b00",
      one_one: "2'b11"
    }}, // err: "2'b01"},
    {name: 'one_one', next: {
      one_zero: "2'b10",
      zero_one: "2'b01"
    }}, // err: "2'b00"},
    // err: {}
  ]
}) */
// ***** THIS TEXT IS AUTOMATICALY GENERATED, DO NOT EDIT *****
reg [1:0] FSM_state, FSM_next;



// FSM state enums
wire [1:0] FSM_zero_zero = 0;
wire [1:0] FSM_zero_one  = 1;
wire [1:0] FSM_one_zero  = 2;
wire [1:0] FSM_one_one   = 3;

// FSM transition conditions
wire FSM_zero_zero_zero_one = ((FSM_state == FSM_zero_zero) & (2'b01 == {a, b}));
wire FSM_zero_zero_one_zero = ((FSM_state == FSM_zero_zero) & (2'b10 == {a, b}));
wire FSM_zero_one_one_one   = ((FSM_state == FSM_zero_one ) & (2'b11 == {a, b}));
wire FSM_zero_one_zero_zero = ((FSM_state == FSM_zero_one ) & (2'b00 == {a, b}));
wire FSM_one_zero_zero_zero = ((FSM_state == FSM_one_zero ) & (2'b00 == {a, b}));
wire FSM_one_zero_one_one   = ((FSM_state == FSM_one_zero ) & (2'b11 == {a, b}));
wire FSM_one_one_one_zero   = ((FSM_state == FSM_one_one  ) & (2'b10 == {a, b}));
wire FSM_one_one_zero_one   = ((FSM_state == FSM_one_one  ) & (2'b01 == {a, b}));

// FSM state enter conditions
wire FSM_zero_one_onEnter  = (FSM_zero_zero_zero_one & FSM_one_one_zero_one);
wire FSM_one_zero_onEnter  = (FSM_zero_zero_one_zero & FSM_one_one_one_zero);
wire FSM_one_one_onEnter   = (FSM_zero_one_one_one & FSM_one_zero_one_one);
wire FSM_zero_zero_onEnter = (FSM_zero_one_zero_zero & FSM_one_zero_zero_zero);
// FSM state exit conditions
wire FSM_zero_zero_onExit  = (FSM_zero_zero_zero_one & FSM_zero_zero_one_zero);
wire FSM_zero_one_onExit   = (FSM_zero_one_one_one & FSM_zero_one_zero_zero);
wire FSM_one_zero_onExit   = (FSM_one_zero_zero_zero & FSM_one_zero_one_one);
wire FSM_one_one_onExit    = (FSM_one_one_one_zero & FSM_one_one_zero_one);

// FSM next state select
always @(*) begin : FSM_next_select
  case (1'b1)
    FSM_zero_zero_zero_one : FSM_next = FSM_zero_one;
    FSM_zero_zero_one_zero : FSM_next = FSM_one_zero;
    FSM_zero_one_one_one   : FSM_next = FSM_one_one;
    FSM_zero_one_zero_zero : FSM_next = FSM_zero_zero;
    FSM_one_zero_zero_zero : FSM_next = FSM_zero_zero;
    FSM_one_zero_one_one   : FSM_next = FSM_one_one;
    FSM_one_one_one_zero   : FSM_next = FSM_one_zero;
    FSM_one_one_zero_one   : FSM_next = FSM_zero_one;
    default                : FSM_next = FSM_state;
  endcase
end

always @(posedge clk or negedge reset_n)
  if (~reset_n) FSM_state <= FSM_zero_zero;
  else          FSM_state <= FSM_next;

reg [71:0] FSM_state_ascii;
always @(*)
  case ({FSM_state})
    FSM_zero_zero : FSM_state_ascii = "zero_zero";
    FSM_zero_one  : FSM_state_ascii = "zero_one ";
    FSM_one_zero  : FSM_state_ascii = "one_zero ";
    FSM_one_one   : FSM_state_ascii = "one_one  ";
    default       : FSM_state_ascii = "%Error   ";
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
