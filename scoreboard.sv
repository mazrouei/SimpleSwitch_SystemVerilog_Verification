`ifndef SCOREBOARD__SV
 `define SCOREBOARD__SV
 
 
`include "transaction.sv"


class Scoreboard;

Transaction scbq[$];

function void save_expected (input Transaction tr);
	scbq.push_back(tr);
endfunction


function void compare_actual  (input Transaction tr);

	int q[$];
	q=scbq.find_index(x) with (x.src==tr.src);
	case (q.size())
		0: $display("No match found");
		
		1: scbq.delete(q[0]);
		
		default: $display("Error, multiple match found!");
	
	endcase

endfunction
endclass

`endif // SCOREBOARD__SV

