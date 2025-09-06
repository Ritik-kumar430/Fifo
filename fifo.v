# Fifo
`define DATA_WIDTH 8
`define ADDR_WIDTH 4
`define DEPTH 16

module FIFO (
input clk, rst_n,
input wr_n, rd_n,
input [`DATA_WIDTH-1:0] data_in,
output reg [`DATA_WIDTH-1:0] data_out,
output reg full, empty,
output reg overflow, underflow
);

reg [`DATA_WIDTH-1:0] mem [`DEPTH-1:0];
reg [`ADDR_WIDTH-1:0] wptr, rptr;
reg [`ADDR_WIDTH:0] count;

always @(posedge clk) begin
if (wr_n && !full)
mem[wptr] <= data_in;

if (rd_n && !empty)
data_out <= mem[rptr];
end

always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
wptr <= 0;
rptr <= 0;
count <= 0;
end else begin
if (wr_n && !full) begin
if (wptr == `DEPTH - 1)
wptr <= 0;
else
wptr <= wptr + 1;
end

if (rd_n && !empty) begin

if (rptr == `DEPTH - 1)
rptr <= 0;
else
rptr <= rptr + 1;
end

if (wr_n && !full && rd_n && !empty) begin
count <= count;
end else if (wr_n && !full) begin
count <= count + 1;
end else if (rd_n && !empty) begin
count <= count - 1;
end else begin
count <= count;
end
end
end

always @(*) begin
full = (count == `DEPTH);
empty = (count == 0);
end

always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
overflow <= 0;

underflow <= 0;
end else begin
overflow <= (wr_n && full);
underflow <= (rd_n && empty);
end
end

endmodule
