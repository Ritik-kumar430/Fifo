#Fifo Testbench
`timescale 1ns/1ps
`define DATA_WIDTH 8
`define ADDR_WIDTH 4
`define DEPTH 16

module tb;

reg clk, rst_n;
reg wr_n, rd_n;
reg [`DATA_WIDTH-1:0] data_in;
wire [`DATA_WIDTH-1:0] data_out;
wire full, empty, overflow, underflow;

FIFO uut (
.clk(clk),

.rst_n(rst_n),
.wr_n(wr_n),
.rd_n(rd_n),
.data_in(data_in),
.data_out(data_out),
.full(full),
.empty(empty),
.overflow(overflow),
.underflow(underflow)
);

initial begin
$fsdbDumpfile("dump.fsdb");
$fsdbDumpvars(0, tb);
end

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
rst_n = 0;
wr_n = 0;
rd_n = 0;
data_in = 0;

#12 rst_n = 1;

#10 data_in = 8'hA1; wr_n = 1;
#10 wr_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b data_in=%h => data_out=%h
full=%b empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_in, data_out, full, empty, overflow, underflow);

#10 data_in = 8'hB2; wr_n = 1;
#10 wr_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b data_in=%h => data_out=%h
full=%b empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_in, data_out, full, empty, overflow, underflow);

#10 data_in = 8'hC3; wr_n = 1;
#10 wr_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b data_in=%h => data_out=%h
full=%b empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_in, data_out, full, empty, overflow, underflow);

#10 rd_n = 1;
#10 rd_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b => data_out=%h full=%b
empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_out, full, empty, overflow, underflow);

#10 rd_n = 1;

#10 rd_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b => data_out=%h full=%b
empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_out, full, empty, overflow, underflow);

#10 data_in = 8'hD4; wr_n = 1;
#10 wr_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b data_in=%h => data_out=%h
full=%b empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_in, data_out, full, empty, overflow, underflow);

#10 rd_n = 1;
#10 rd_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b => data_out=%h full=%b
empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_out, full, empty, overflow, underflow);

#10 rd_n = 1;
#10 rd_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b => data_out=%h full=%b
empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_out, full, empty, overflow, underflow);

repeat (16) begin
#10 data_in = $random; wr_n = 1;
#10 wr_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b data_in=%h => data_out=%h
full=%b empty=%b overflow=%b underflow=%b",

$time, clk, rst_n, wr_n, rd_n, data_in, data_out, full, empty, overflow, underflow);
end

#10 data_in = 8'hFF; wr_n = 1;
#10 wr_n = 0;
$display("[%0t] clk=%b rst_n=%b wr_n=%b rd_n=%b data_in=%h => data_out=%h
full=%b empty=%b overflow=%b underflow=%b",
$time, clk, rst_n, wr_n, rd_n, data_in, data_out, full, empty, overflow, underflow);

#20 $finish;
end
endmodule

endmodule
