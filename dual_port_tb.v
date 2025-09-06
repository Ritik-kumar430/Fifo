`timescale 1ns/1ps

module tb_dual_port_ram;

  // Parameters
  localparam DATA_WIDTH = 8;
  localparam ADDR_WIDTH = 4;

  // Signals
  logic clk;
  logic we_a, we_b;
  logic [ADDR_WIDTH-1:0] addr_a, addr_b;
  logic [DATA_WIDTH-1:0] din_a, din_b;
  logic [DATA_WIDTH-1:0] dout_a, dout_b;
  logic collision;

  // DUT instantiation
  dual_port_ram #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .clk(clk),
    .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a),
    .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b),
    .collision(collision)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 10ns clock period

  // Test sequence
  initial begin
    // Initialize
    we_a = 0; we_b = 0;
    addr_a = 0; addr_b = 0;
    din_a = 0; din_b = 0;

    #10;

    $display("=== CASE 1: Only Port A writes ===");
    addr_a = 4'h1; din_a = 8'hAA; we_a = 1; we_b = 0;
    #10;
    we_a = 0;
    #10;
    $display("PortA Read: dout_a=%h (expect AA)", dout_a);

    $display("=== CASE 2: Only Port B writes ===");
    addr_b = 4'h2; din_b = 8'hBB; we_b = 1; we_a = 0;
    #10;
    we_b = 0;
    #10;
    $display("PortB Read: dout_b=%h (expect BB)", dout_b);

    $display("=== CASE 3: Both write different addresses ===");
    addr_a = 4'h3; din_a = 8'hCC; we_a = 1;
    addr_b = 4'h4; din_b = 8'hDD; we_b = 1;
    #10;
    we_a = 0; we_b = 0;
    #10;
    $display("PortA Read: dout_a=%h (expect CC)", dout_a);
    $display("PortB Read: dout_b=%h (expect DD)", dout_b);

    $display("=== CASE 4: Both write SAME address (collision) ===");
    addr_a = 4'h5; din_a = 8'hEE; we_a = 1;
    addr_b = 4'h5; din_b = 8'hFF; we_b = 1;
    #10;
    we_a = 0; we_b = 0;
    #10;
    $display("Collision=%b, PortA Read: dout_a=%h (expect EE, PortA wins)", collision, dout_a);

    $display("=== CASE 5: Both read SAME address ===");
    addr_a = 4'h1; addr_b = 4'h1; // both read from addr=1
    #10;
    $display("PortA dout=%h, PortB dout=%h (expect AA, AA)", dout_a, dout_b);

    $display("=== CASE 6: One writes while other reads ===");
    addr_a = 4'h6; din_a = 8'h99; we_a = 1; // write
    addr_b = 4'h6; we_b = 0; // read
    #10;
    we_a = 0;
    #10;
    $display("PortB Read after write: dout_b=%h (expect 99)", dout_b);

    $display("=== ALL CASES DONE ===");
    #20 $finish;
  end

  // FSDB waveform dumping (if using Verdi or similar)
  initial begin
    $fsdbDumpfile("dump.fsdb");
    $fsdbDumpvars(0, tb_dual_port_ram);
  end

endmodule
