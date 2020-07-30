`timescale 1ns / 1ns

module RLE_Set_tb;
	reg clk, rst;
	reg [7:0] T;

	wire [15:0] R_code, G_code, B_code;
	wire done, NR;
	integer rf, gf, bf;
	
	RLE_Set uut (
		.clk(clk), 
		.rst(rst), 
		.T(T), 
		.done(done),
		.NR(NR),
		.R_code(R_code),
		.G_code(G_code),
		.B_code(B_code)		
	);

	initial begin
		clk = 0;
		rst = 0;
		T = 0;
		#2 rst = 1; #7 rst = 0;
	end
	
	initial forever #10 clk = ~clk;
	
	initial begin 
		#20;
		
		rf = $fopen("test/encoded/R.txt", "w");
		gf = $fopen("test/encoded/G.txt", "w");
		bf = $fopen("test/encoded/B.txt", "w");
		
		while (~done) begin
			#20;
			
			if (R_code > 0)
				$fwrite(rf, "%0d,", R_code);
				//$fwrite(rf, "%0d,%0d ", R_code[15:8], R_code[7:0]);
			if (NR)
				$fwrite(rf, "\n");
				
			if (G_code > 0)
				$fwrite(gf, "%0d,", G_code);
				//$fwrite(gf, "%0d,%0d ", G_code[15:8], G_code[7:0]);
			if (NR)
				$fwrite(gf, "\n");

			if (B_code > 0)
				$fwrite(bf, "%0d,", B_code);
				//$fwrite(bf, "%0d,%0d ", B_code[15:8], B_code[7:0]);
			if (NR)
				$fwrite(bf, "\n");				
		end

		$fclose(rf);
		$fclose(gf);
		$fclose(bf);
		rf = 0;
		gf = 0;
		bf = 0;	
	end
	 	
endmodule
