module eb_fifo_ctrl #(
  parameter DEPTHMO = 4'd15,
  parameter AW = 3
) (
  input               t_0_req,
  output              t_0_ack,
  output reg          i_0_req,
  input               i_0_ack,
  output reg [AW-1:0] waddr,
  output     [AW-1:0] raddr,
  output              wen, ren,
  input               clock, reset_n
);

reg [AW-1:0] status_cnt;
reg [AW-1:0] q_raddr;

assign t_0_ack = !(status_cnt == DEPTHMO);
assign ren = 1'b1;
assign wen = t_0_req && t_0_ack;
assign raddr = (i_0_req & i_0_ack)
  ? (((q_raddr == DEPTHMO) && (status_cnt != {AW{1'b0}}))
    ? {AW{1'b0}}
    : (q_raddr + {{AW-1{1'b0}}, 1'b1})
  )
  : q_raddr;

always @(posedge clock or negedge reset_n)
  if (~reset_n)
    i_0_req <= 1'b0;
  else if (status_cnt == {AW{1'b0}} && !(t_0_req && t_0_ack))
    i_0_req <= 1'b0;
  else if ((i_0_req && i_0_ack) && !(t_0_req && t_0_ack) && (status_cnt == {{AW-1{1'b0}}, 1'b1}))
    i_0_req <= 1'b0;
  else
    i_0_req <= 1'b1;

always @(posedge clock or negedge reset_n)
  if (~reset_n)
    waddr <= {AW{1'b0}};
  else if (t_0_req && t_0_ack)
    if (waddr == DEPTHMO)
      waddr <= {AW{1'b0}};
    else
      waddr <= waddr + {{AW-1{1'b0}}, 1'b1};

always @(posedge clock or negedge reset_n)
  if (~reset_n)
    q_raddr <= {AW{1'b0}};
  else if (i_0_req && i_0_ack)
    if ((q_raddr == DEPTHMO) && (status_cnt != {AW{1'b0}}))
      q_raddr <= {AW{1'b0}};
    else
      q_raddr <= q_raddr + {{AW-1{1'b0}}, 1'b1};

always @(posedge clock or negedge reset_n)
  if (~reset_n)
    status_cnt <= {AW{1'b0}};
  else if ((i_0_req && i_0_ack) && (t_0_req && t_0_ack))
    status_cnt <= status_cnt;
  else if (i_0_req && i_0_ack && (status_cnt != {AW{1'b0}}))
    status_cnt <= status_cnt - {{AW-1{1'b0}}, 1'b1};
  else if (t_0_req && t_0_ack)
    status_cnt <= status_cnt + {{AW-1{1'b0}}, 1'b1};

endmodule // eb_fifo_ctrl
