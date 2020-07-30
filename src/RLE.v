`timescale 1ns / 1ps

module RLE(rst, clk, NR, E, T, R, G, B, R_code, G_code, B_code, done);
	input rst, clk, E;
	input [7:0] T;
	input [7:0] R, G, B;
	output reg [15:0] R_code, G_code, B_code;
	output reg done, NR;
	
	reg[7:0] r_cnt, g_cnt, b_cnt;
	reg[8:0] r_cur, g_cur, b_cur;
	reg [8:0] i, j;
	parameter [8:0] MAX_CUR = 511;
	parameter [6:0] MAX_I = 127;
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			R_code = 0;
			G_code = 0;
			B_code = 0;
			done = 0;
			r_cnt = 0;
			g_cnt = 0;
			b_cnt = 0;
			r_cur = MAX_CUR;
			g_cur = MAX_CUR;
			b_cur = MAX_CUR;
			i = 0;
			j = 0;
			NR = 0;
		end
		else begin
			NR = 0;
			if (E) begin
				if (r_cur == MAX_CUR) begin
					R_code = 0;
					r_cnt = 1;
					r_cur = R;					
				end
				else if (i == MAX_I && ((R-r_cur >= 0 && R-r_cur <= T) || (r_cur-R >= 0 && r_cur-R <= T))) begin
					r_cnt = r_cnt + 1;
					R_code = {r_cnt, r_cur[7:0]};
					r_cnt = 0;
					r_cur = MAX_CUR;					
				end
				else if ((R-r_cur >= 0 && R-r_cur <= T) || (r_cur-R >= 0 && r_cur-R <= T)) begin
					r_cnt = r_cnt + 1;
					R_code = 0;
				end
				else begin
					R_code = {r_cnt, r_cur[7:0]};
					r_cnt = 1;
					r_cur = R;
				end
				
				if (g_cur == MAX_CUR) begin
					G_code = 0;
					g_cnt = 1;
					g_cur = G;					
				end
				else if (i == MAX_I && ((G-g_cur >= 0 && G-g_cur <= T) || (g_cur-G >= 0 && g_cur-G <= T))) begin
					g_cnt = g_cnt + 1;
					G_code = {g_cnt, g_cur[7:0]};
					g_cnt = 0;
					g_cur = MAX_CUR;					
				end
				else if ((G-g_cur >= 0 && G-g_cur <= T) || (g_cur-G >= 0 && g_cur-G <= T)) begin
					g_cnt = g_cnt + 1;
					G_code = 0;
				end
				else begin
					G_code = {g_cnt, g_cur[7:0]};
					g_cnt = 1;
					g_cur = G;
				end

				if (b_cur == MAX_CUR) begin
					B_code = 0;
					b_cnt = 1;
					b_cur = B;					
				end
				else if (i == MAX_I && ((B-b_cur >= 0 && B-b_cur <= T) || (b_cur-B >= 0 && b_cur-B <= T))) begin
					b_cnt = b_cnt + 1;
					B_code = {b_cnt, b_cur[7:0]};
					b_cnt = 0;
					b_cur = MAX_CUR;					
				end
				else if ((B-b_cur >= 0 && B-b_cur <= T) || (b_cur-B >= 0 && b_cur-B <= T)) begin
					b_cnt = b_cnt + 1;
					B_code = 0;
				end
				else begin
					B_code = {b_cnt, b_cur[7:0]};
					b_cnt = 1;
					b_cur = B;
				end				
				
				i = i + 1;
				if (i > MAX_I)
					j = j + 1;
			end
			else begin
				if (j > MAX_I) begin
					j = j + 1;
					if (j >= MAX_I + 8)
						done = 1;
				end				
				if (i == MAX_I + 1) begin
					if (r_cur == MAX_CUR)
						R_code = 0;
					else
						R_code = {r_cnt, r_cur[7:0]};					
					r_cnt = 0;
					r_cur = MAX_CUR;
					
					if (g_cur == MAX_CUR)
						G_code = 0;
					else
						G_code = {g_cnt, g_cur[7:0]};					
					g_cnt = 0;
					g_cur = MAX_CUR;

					if (b_cur == MAX_CUR)
						B_code = 0;
					else
						B_code = {b_cnt, b_cur[7:0]};					
					b_cnt = 0;
					b_cur = MAX_CUR;					
					
					NR = 1;
					i = 0;
				end				
				else begin
					R_code = 0;
					G_code = 0;
					B_code = 0;
				end				
			end		
		end
	end
endmodule
