`ifndef MONITOR__SV
 `define MONITOR__SV
 
`include "transaction.sv"
`include "bus.sv"

virtual class Monitor_cbs;
   

   virtual task post_rx(ref Transaction tr);
   //////
   endtask : post_rx
endclass : Monitor_cbs



class Monitor;
	Monitor_cbs cbs[$]; 
	vBusTx Tx;		
    int PortID;

	function new (input vBusTx Tx);
		this.gen2drv = gen2drv;
		this.Tx = Tx;
	endfunction


	virtual task run();
		bit[31:0] mem[$];
		Transaction tr;
		forever begin
		int i = 0;
		@(posedge Tx.cbt.sop);
		mem[0]<=Tx.cbt.port;
		while (Tx.cbt.eop == 0) begin
		@Tx.cbt;
		mem[i]<=Tx.cbt.port;
		i++;
		end
		tr.unpack(mem);
		foreach(cbs[i])  cbs[i].post_rx(tr);
		end
	endtask
endclass

`endif // MONITOR__SV