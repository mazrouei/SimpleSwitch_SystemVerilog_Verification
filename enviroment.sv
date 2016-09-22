`ifndef ENVIROMENT__SV
 `define ENVIROMENT__SV
 
 
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "bus.sv"



class Driver_cbs_drop extends Driver_cbs;
   virtual task pre_tx(ref Transaction tr, ref bit drop);
		drop = ($urandom_range(0,99) == 0);
   endtask 
endclass 



class Driver_cbs_scoreboard extends Driver_cbs;
Scoreboard scb;

   virtual task pre_tx(ref Transaction tr, ref bit drop);
		scb.save_expected(tr);
   endtask 
   
   function new (input Scoreboard scb);
	this.scb = scb;   
   endfunction
endclass



class Monitor_cbs_scoreboard extends Monitor_cbs;
Scoreboard scb;

   virtual task post_rx(ref Transaction tr);
		scb.compare_actual(tr);
   endtask 
   
   function new (input Scoreboard scb);
	this.scb = scb;   
   endfunction
endclass 


class Enviroment;

Generator gen[];
Driver drv[];
Monitor mon[];
Scoreboard scb;
Coverage cov;
mailbox #(Transaction) gen2drv[];
vBusRx Rx[];
vBusTx Tx[];
int numRx, numTx;


function new (input vBusRx Rx[], input  vBusTx Tx[], input int  NumRx, NumTx, length_min, length_max);

	this.Rx=new[Rx.size()];
	foreach (Rx[i]) this.Rx[i] = Rx[i];
	this.Tx=new[Tx.size()];
	foreach (Tx[i]) this.Tx[i] = Tx[i];
	this.numRx = numRx;
	this.numTx = numTx;
	
	
	if ($test$plusargs("ntb_random_seed")) begin
      int seed;
      $value$plusargs("ntb_random_seed=%d", seed);
      $display("Simulation run with random seed=%0d", seed);
   end
   else
     $display("Simulation run with default random seed");
endfunction


virtual function void build();
	gen2drv = new[numRx];
	gen = new[numRx];
	drv = new[numRx];
	scb = new();
	cov = new();
	
	foreach(gen[i]) begin
      gen2drv[i] = new();
      gen[i] = new(gen2drv[i], length_min, length_max);
      drv[i] = new(gen2drv[i], Rx[i]);
   end

   mon = new[numTx];
   foreach (mon[i])
     mon[i] = new(Tx[i], i);

  
   begin
      Scb_Driver_cbs sdc = new(scb);
      Scb_Monitor_cbs smc = new(scb);
      foreach (drv[i]) drv[i].cbsq.push_back(sdc);  
      foreach (mon[i]) mon[i].cbsq.push_back(smc); 

 
   begin
      Cov_Monitor_cbs smc = new(cov);
      foreach (mon[i]) mon[i].cbsq.push_back(smc);  
   end
endfunction


virtual task run();
	fork
		gen.run();
		drv.run();
		mon.run();
	join
endtask

virtual task wrap_up();
////
endtask

endclass

`endif // ENVIROMENT__SV