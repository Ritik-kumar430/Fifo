module dual_port_ram #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4
)(
  input logic clk,
  input logic we_a,
  input logic [ADDR_WIDTH-1:0] addr_a,
  input logic [DATA_WIDTH-1:0] din_a,
  output logic [DATA_WIDTH-1:0] dout_a,
  input logic we_b,
  input logic [ADDR_WIDTH-1:0] addr_b,
  input logic [DATA_WIDTH-1:0] din_b,
  output logic [DATA_WIDTH-1:0] dout_b,
  output logic collision
);

  logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

  always_ff @(posedge clk) begin
    collision <= 0;

    if (we_a && we_b && (addr_a == addr_b)) begin
      mem[addr_a] <= din_a;
      collision <= 1;
    end 
    else if (we_a && we_b) begin
      mem[addr_a] <= din_a;
      mem[addr_b] <= din_b;
    end 
    else if (we_a) begin
      mem[addr_a] <= din_a;
    end 
    else if (we_b) begin
      mem[addr_b] <= din_b;
    end

    dout_a <= mem[addr_a];
    dout_b <= mem[addr_b];
  end

endmodule
