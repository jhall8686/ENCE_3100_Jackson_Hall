module ms_dff(
	input Clk,
	input D,
	output Q
	);
	wire Qm;
	dlatchv1 d0(~Clk, D, Qm);
	dlatchv1 d1(Clk, Qm, Q);
	
endmodule