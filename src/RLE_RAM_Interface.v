`timescale 1ns / 1ps

module RLE_RAM_Interface(clk, rst, a, spo, E, R, G, B);
	input clk, rst;
	input [7:0] spo;
	output reg E;
	output reg [15:0] a;
	output reg [7:0] R, G, B;
	
	parameter HOLD_CLK = 1;
	reg [15:0] hold_cnt;
	
	parameter RBA = 0, GBA = 16384, BBA = 32768;
	reg [14:0] offset;
	
	reg [2:0] state;
	parameter [2:0] r1 = 0, r2 = 1, g1 = 2, g2 = 3, b1 = 4, b2 = 5, hold = 6;
		
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			E = 0;
			R = 0;
			G = 0;
			B = 0;
			offset = 0;
			state = r1;
			hold_cnt = 0;
		end
		else begin
			E = 0;
			if (offset < GBA) begin
				if (state == r1) begin
					a = offset + RBA;
					state = r2;
				end
				else if (state == r2) begin
					R = spo;
					state = g1;
				end

				else if (state == g1) begin
					a = offset + GBA;
					state = g2;
				end
				else if (state == g2) begin
					G = spo;
					state = b1;
				end
				
				else if (state == b1) begin
					a = offset + BBA;
					state = b2;
				end
				else if (state == b2) begin
					B = spo;
					E = 1;
					offset = offset + 1;					
					state = hold;
				end

				else if (state == hold) begin
					hold_cnt = hold_cnt + 1;
					if (hold_cnt >= HOLD_CLK) begin
						hold_cnt = 0;
						state = r1;
					end
				end				
			end
		end
	end
endmodule
