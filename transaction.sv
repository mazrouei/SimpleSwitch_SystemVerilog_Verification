`ifndef TRANSACTION__SV
  `define TRANSACTION__SV


class Transaction;
int length_max, lenght_min;
rand bit [31:0] src, dst, data[];
bit [31:0] csm;

constraint cdata_length {data.size() inside {[length_min:length_max]}; }

function new (input int lenght_min, length_max);
	this.lenght_min = lenght_min;
	this.length_max = length_max;
endfunction


virtual function Transaction copy ();
	copy = new ();
	copy.src = this.src;
	copy.dst = this.dst;
	copy.data = this.data; 
	copy.csm = this.csm;
	copy.length_max = this.length_max; 
	copy.lenght_min = this.lenght_min; 
	return copy;
endfunction

virtual function void pack(ref bit[31:0] dwords[$]);
	dwords = {>> {dst, src, data, csm}};
endfunction

virtual function void unpack(ref bit[31:0] dwords[$]);
	{>> {dst, src, data, csm}}= dwords;
endfunction

virtual function void calc_csm ();
	csm=src ^ dst ^ data.xor;
endfunction


virtual function void didplay (input string prefix="");
	$display("%sTr: src=%h, dst=%h, csm=%h, data_size=%d", prefix, src, dst, csm, data.size());
endfunction
endclass



class BadTr extends Transaction;
rand bit bad_sum;


function new (input int lenght_min, length_max);
	super.new(lenght_min, length_max);
endfunction

virtual function Transaction copy ();
	BadTr bad;
	bad = new ();
	bad.src = this.src;
	bad.dst = this.dst;
	bad.data = this.data; 
	bad.csm = this.csm;
	bad.length_max = this.length_max; 
	bad.lenght_min = this.lenght_min;
	bad.bad_csm= this.bad_csm;
	return bad;
endfunction

virtual function void calc_csm ();
	super.calc_csm();
	if (bad_sum) csm = ~csm;
endfunction

virtual function void didplay (input string prefix="");
	$display("%sBadTr: bad_csm=%b, ", prefix, bad_csm);
	super.display();
endfunction
endclass

`endif  
