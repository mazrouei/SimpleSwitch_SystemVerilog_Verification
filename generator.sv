`ifndef GENERATOR__SV
 `define GENERATOR__SV
 
 
`include "transaction.sv"

class Generator;

mailbox #(Transaction) gen2drv;
Transaction blueprint;

function new (input mailbox #(Transaction) gen2drv, input int lenght_min, length_max)
	this.gen2drv = gen2drv;
	blueprint = new (lenght_min, length_max);
endfunction

virtual task run(input int num_tr = 20);
repeat (num_tr)  begin
	'SV_RAND_CHECK(blueprint.randomize());
	gen2drv.put(blueprint.copy());

end
endtask
endclass

`endif // GENERATOR__SV