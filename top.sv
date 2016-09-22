`timescale 1ns/1ns

`define TxPorts 4  
`define RxPorts 4  

module top;


parameter int NumRx = `RxPorts;
parameter int NumTx = `TxPorts;
  
  
logic clk, rst;
	
Bus Rx[0:NumRx-1] (clk);
Bus Tx[0:NumTx-1] (clk);


test #(NumRx, NumTx)  t1(Rx,Tx,rst);
simple_switch #(NumRx, NumTx)  a1(Rx,Tx,clk,rst);


	
initial begin
    rst = 0; clk = 0;
    #5ns rst = 1;
    #5ns clk = 1;
    #5ns rst = 0; clk = 0;
    forever 
      #5ns clk = ~clk;
  end

endmodule