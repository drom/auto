module quadrature (
  input clk, reset_n, a, b,
  output err,
  output reg [7:0] counter
);

/* fsm({
  clock: 'clk',
  asyncReset: '~reset_n',
  cond: '{a, b}',
  ascii: true,
  states: {
    s00: {s01: "2'b01", s10: "2'b10"}, // err: "2'b11"},
    s01: {s11: "2'b11", s00: "2'b00"}, // err: "2'b10"},
    s11: {s10: "2'b10", s01: "2'b01"}, // err: "2'b00"},
    s10: {s00: "2'b00", s11: "2'b11"}, // err: "2'b01"},
    // err: {}
  }
}) */
reg [1:0] FSM_state, FSM_next;



// FSM state enums
wire [1:0] FSM_s00 = 0;
wire [1:0] FSM_s01 = 1;
wire [1:0] FSM_s11 = 2;
wire [1:0] FSM_s10 = 3;

// FSM transition conditions
wire FSM_s00_s01 = ((FSM_state == FSM_s00) & (2'b01 == {a, b}));
wire FSM_s00_s10 = ((FSM_state == FSM_s00) & (2'b10 == {a, b}));
wire FSM_s01_s11 = ((FSM_state == FSM_s01) & (2'b11 == {a, b}));
wire FSM_s01_s00 = ((FSM_state == FSM_s01) & (2'b00 == {a, b}));
wire FSM_s11_s10 = ((FSM_state == FSM_s11) & (2'b10 == {a, b}));
wire FSM_s11_s01 = ((FSM_state == FSM_s11) & (2'b01 == {a, b}));
wire FSM_s10_s00 = ((FSM_state == FSM_s10) & (2'b00 == {a, b}));
wire FSM_s10_s11 = ((FSM_state == FSM_s10) & (2'b11 == {a, b}));

// FSM next state select
always @(*) begin : FSM_next_select
  case (1'b1)
    FSM_s00_s01: FSM_next = FSM_s01;
    FSM_s00_s10: FSM_next = FSM_s10;
    FSM_s01_s11: FSM_next = FSM_s11;
    FSM_s01_s00: FSM_next = FSM_s00;
    FSM_s11_s10: FSM_next = FSM_s10;
    FSM_s11_s01: FSM_next = FSM_s01;
    FSM_s10_s00: FSM_next = FSM_s00;
    FSM_s10_s11: FSM_next = FSM_s11;
  endcase
end

always_ff @(posedge clk or negedge reset_n)
  if (~reset_n) FSM_state <= FSM_s00;
  else          FSM_state <= FSM_next;

reg [23:0] FSM_state_ascii;
always @(*)
  case ({FSM_state})
    FSM_s00: FSM_state_ascii = "s00";
    FSM_s01: FSM_state_ascii = "s01";
    FSM_s11: FSM_state_ascii = "s11";
    FSM_s10: FSM_state_ascii = "s10";
    default: FSM_state_ascii = "%Er";
  endcase

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
