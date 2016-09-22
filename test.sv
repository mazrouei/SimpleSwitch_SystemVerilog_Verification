`include "enviroment.sv"

program automatic  test  #(parameter int NumRx = 2, parameter int NumTx = 2)
 (Bus.TB_Rx Rx[0:NumRx-1], Bus.TB_Tx Tx[0:NumTx-1], input logic rst);

Enviroment env;

initial begin
	
	env = new();
	env.build();
	
	begin
	BadTr bad = new(Rx, Tx, NumRx, NumTx);
	env.gen.blueprint = bad;
	
	Driver_cbs_drop dcd= new();
	env.drv.cbs.push_back(dcd);


	Driver_cbs_scoreboard dcs= new(env.scb);
	env.drv.cbs.push_back(dcs);	
	
	Monitor_cbs_scoreboard mcs= new(env.scb);
	env.mon.cbs.push_back(mcs);
	end
	
	env.run;
	env.wrap_up();
end
endprogram

