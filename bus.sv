`ifndef BUS__SV
  `define BUS__SV
  
interface Bus (input logic clk);
	logic [31:0] port;
	logic sop, eop;
	
	
   clocking cbr @(posedge clk);
      output port, sop, eop;
   endclocking : cbr
   modport TB_Rx (clocking cbr);

   clocking cbt @(posedge clk);
      input port, sop, eop;
   endclocking : cbt
   modport TB_Rx (clocking cbr);

endinterface

typedef virtual Bus vBus;
typedef virtual Bus.TB_Rx vBusRx;
typedef virtual Bus.TB_Tx vBusTx;

`endif  