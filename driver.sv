`ifndef DRIVER__SV
 `define DRIVER__SV
 
`include "transaction.sv"
`include "bus.sv"


virtual class Driver_cbs;
   virtual task pre_tx(ref Transaction tr, ref bit drop);
   //////
   endtask : pre_tx

   virtual task post_tx(ref Transaction tr);
   //////
   endtask : post_tx
endclass : Driver_cbs



class Driver;
	Driver_cbs cbs[$]; 
	mailbox #(Transaction) gen2drv;
	vBusRx Rx;

	function new (input mailbox #(Transaction) gen2drv, input, vBusRx Rx);
		this.gen2drv = gen2drv;
		this.Rx = Rx;
	endfunction


	virtual task run();
		bit drop;
		Transaction tr;
		forever begin
		gen2drv.get(tr);
		tr.calc_csm();
		foreach(cbs[i])  cbs[i].pre_tx(tr,drop);
		if (drop) continue;
		//// transmit tr
		@Rx.cbr;
		begin
		sop<=1'b1;
		Rx.cb.port<=tr.dst;
		end
		@Rx.cbr;
		begin
		sop<=0;
		Rx.cb.port<=tr.src;
		end
		for (int i=0; i<tr.data.size();i++)  begin
		@Rx.cbr;
		Rx.cb.port<=tr.data[i];
		end
		@Rx.cbr;
		eop<=1;
		@Rx.cbr;
		eop<=0;
		end
		end
		/// 
		foreach(cbs[i])  cbs[i].post_tx(tr);	
		
		
		end
	endtask
endclass

`endif // DRIVER__SV