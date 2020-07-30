`timescale 1ns / 1ps

module RLD(rst, clk, start, R_code, G_code, B_code, R, G, B, done, valid, NR);
	input rst, clk;
	input [2:0] start;
	input [15:0] R_code, G_code, B_code;
	output reg [7:0] R, G, B;
	output reg [2:0] valid, NR, done;
	
	parameter [6:0] MAX_I = 127;
	
	reg [15:0] r_c, r_din;
	reg [7:0] r_cnt, r_cur;
	reg r_wr, r_rd;
	reg [7:0] r_i, r_j;
	reg [1:0] r_k;
	wire r_full, r_empty, r_valid;
	wire [15:0] r_dout;
	
	reg [15:0] g_c, g_din;
	reg [7:0] g_cnt, g_cur;
	reg g_wr, g_rd;
	reg [7:0] g_i, g_j;
	reg [1:0] g_k;
	wire g_full, g_empty, g_valid;
	wire [15:0] g_dout;

	reg [15:0] b_c, b_din;
	reg [7:0] b_cnt, b_cur;
	reg b_wr, b_rd;
	reg [7:0] b_i, b_j;
	reg [1:0] b_k;
	wire b_full, b_empty, b_valid;
	wire [15:0] b_dout;		

	Buff R_BUF (
	  .clk(clk),
	  .rst(rst),
	  .din(r_din),
	  .wr_en(r_wr),
	  .rd_en(r_rd),
	  .dout(r_dout),
	  .full(r_full),
	  .empty(r_empty),
	  .valid(r_valid)
	);
	
	Buff G_BUF (
	  .clk(clk),
	  .rst(rst),
	  .din(g_din),
	  .wr_en(g_wr),
	  .rd_en(g_rd),
	  .dout(g_dout),
	  .full(g_full),
	  .empty(g_empty),
	  .valid(g_valid)
	);	
	
	Buff B_BUF (
	  .clk(clk),
	  .rst(rst),
	  .din(b_din),
	  .wr_en(b_wr),
	  .rd_en(b_rd),
	  .dout(b_dout),
	  .full(b_full),
	  .empty(b_empty),
	  .valid(b_valid)
	);		
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			r_din <= 0;
			r_wr <= 0;
			
			g_din <= 0;
			g_wr <= 0;

			b_din <= 0;
			b_wr <= 0;				
		end
		else begin
			if (R_code > 0 && ~r_full && start[0]) begin
				r_din <= R_code;
				r_wr <= 1;
			end
			else begin
				r_wr <= 0;
			end

			if (G_code > 0 && ~g_full && start[1]) begin
				g_din <= G_code;
				g_wr <= 1;
			end
			else begin
				g_wr <= 0;
			end

			if (B_code > 0 && ~b_full && start[2]) begin
				b_din <= B_code;
				b_wr <= 1;
			end
			else begin
				b_wr <= 0;
			end			
		end
	end
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			done = 0;
			valid = 0;
			NR = 0;
			R = 0;
			G = 0;
			B = 0;			
			
			r_rd = 0;
			r_c = 0;
			r_cur = 0;
			r_cnt = 0;
			r_i = 0;
			r_j = 0;
			r_k = 0;

			g_rd = 0;
			g_c = 0;
			g_cur = 0;
			g_cnt = 0;
			g_i = 0;
			g_j = 0;
			g_k = 0;

			b_rd = 0;
			b_c = 0;
			b_cur = 0;
			b_cnt = 0;
			b_i = 0;
			b_j = 0;
			b_k = 0;			
		end
		else begin			
			
			// R Section
			if (r_cnt == 0 && r_c == r_dout && ~r_empty && ~r_wr) begin
				r_rd = 1;
				if (r_i == 0)
					r_c = 0;
			end
			else begin
				r_rd = 0;
			end			
			
			if (r_i == 0)
				if (r_k == 3)
					r_k = 0;
				else
					r_k = r_k + 1;
			
			if (r_cnt == 0 && r_dout > 0 && r_c != r_dout && r_valid && r_k == 0) begin
				r_c = r_dout;
				r_cnt = r_dout[15:8];
				r_cur = r_dout[7:0];
			end
			
			if (r_cnt > 0) begin
				R = r_cur;
				valid[0] = 1;
				r_cnt = r_cnt - 1;
				r_i = r_i + 1;
			end
			else begin
				valid[0] = 0;
			end

			if (r_i == MAX_I + 1 && r_cnt == 0) begin
				r_j = r_j + 1;
				NR[0] = 1;
				r_i = 0;
			end
			else begin
				NR[0] = 0;
			end
			
			if (r_j == MAX_I + 1)
				done[0] = 1;
				
			// G Section
			if (g_cnt == 0 && g_c == g_dout && ~g_empty && ~g_wr) begin
				g_rd = 1;
				if (g_i == 0)
					g_c = 0;
			end
			else begin
				g_rd = 0;
			end			
			
			if (g_i == 0)
				if (g_k == 3)
					g_k = 0;
				else
					g_k = g_k + 1;
			
			if (g_cnt == 0 && g_dout > 0 && g_c != g_dout && g_valid && g_k == 0) begin
				g_c = g_dout;
				g_cnt = g_dout[15:8];
				g_cur = g_dout[7:0];
			end
			
			if (g_cnt > 0) begin
				G = g_cur;
				valid[1] = 1;
				g_cnt = g_cnt - 1;
				g_i = g_i + 1;
			end
			else begin
				valid[1] = 0;
			end

			if (g_i == MAX_I + 1 && g_cnt == 0) begin
				g_j = g_j + 1;
				NR[1] = 1;
				g_i = 0;
			end
			else begin
				NR[1] = 0;
			end
			
			if (g_j == MAX_I + 1)
				done[1] = 1;

			// B Section
			if (b_cnt == 0 && b_c == b_dout && ~b_empty && ~b_wr) begin
				b_rd = 1;
				if (b_i == 0)
					b_c = 0;
			end
			else begin
				b_rd = 0;
			end			
			
			if (b_i == 0)
				if (b_k == 3)
					b_k = 0;
				else
					b_k = b_k + 1;
			
			if (b_cnt == 0 && b_dout > 0 && b_c != b_dout && b_valid && b_k == 0) begin
				b_c = b_dout;
				b_cnt = b_dout[15:8];
				b_cur = b_dout[7:0];
			end
			
			if (b_cnt > 0) begin
				B = b_cur;
				valid[2] = 1;
				b_cnt = b_cnt - 1;
				b_i = b_i + 1;
			end
			else begin
				valid[2] = 0;
			end

			if (b_i == MAX_I + 1 && b_cnt == 0) begin
				b_j = b_j + 1;
				NR[2] = 1;
				b_i = 0;
			end
			else begin
				NR[2] = 0;
			end
			
			if (b_j == MAX_I + 1)
				done[2] = 1;
				
		end
	end
endmodule
