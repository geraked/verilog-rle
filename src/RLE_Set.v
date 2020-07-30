`timescale 1ns / 1ps

module RLE_Set(clk, rst, T, done, NR, R_code, G_code, B_code);
	input clk, rst;
	input [7:0] T;
	output done, NR;
	output [15:0] R_code, G_code, B_code;
	
	parameter HOLD_CLK = 1;
	
	wire [15:0] a;
	wire [7:0] spo;
	wire E;
	wire [7:0] R, G, B;
		
	RAM RLE_Set_RAM (
	  .a(a),
	  .clk(clk),
	  .spo(spo)
	);	
	
	RLE_RAM_Interface RLE_Set_RRI (
		.rst(rst),
		.clk(clk),
		.a(a),
		.spo(spo),
		.E(E),
		.R(R),
		.G(G),
		.B(B)
	);
	defparam RLE_Set_RRI.HOLD_CLK = HOLD_CLK;
	
	RLE RLE_Set_RLE (
		.rst(rst),
		.clk(clk),
		.E(E),
		.T(T),
		.R(R),
		.G(G),
		.B(B),
		.R_code(R_code),
		.G_code(G_code),
		.B_code(B_code),
		.done(done),
		.NR(NR)
	);
endmodule
