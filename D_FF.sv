interface dff_if(input logic clk);
  logic rst;
  logic din;
  logic dout;
endinterface

module dff(dff_if vif);
  always_ff @(posedge vif.clk or posedge vif.rst) begin
    if (vif.rst)
      vif.dout <= 0;
    else
      vif.dout <= vif.din;
  end
endmodule
