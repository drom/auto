module eb_fifo_dpram #(
  parameter DW = 8,
  parameter AW = 4,
  parameter DEPTH = 16
) (
  input       [AW-1:0] waddr, raddr,
  input       [DW-1:0] wdata,
  output reg  [DW-1:0] rdata,
  input wen, ren,
  input clock
);

reg [DW - 1 : 0] mem [DEPTH - 1 : 0];

always @(posedge clock)
  if (ren && wen && (waddr == raddr))
    rdata <= wdata;
  else if(ren)
    rdata <= mem[raddr];

always @(posedge clock)
  if (wen)
    mem[waddr] <= wdata;

endmodule // eb_fifo_dpram
