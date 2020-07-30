`timescale 1ns / 1ns

module Top_tb;
	reg clk, rst;
	reg [7:0] T;
	wire [2:0] valid, NR, done;
	wire [7:0] R, G, B;
	
	integer wrf, wgf, wbf;

	Top uut (
		.clk(clk), 
		.rst(rst), 
		.T(T), 
		.valid(valid), 
		.NR(NR), 
		.done(done), 
		.R(R),
		.G(G),
		.B(B)
	);

	initial begin
		clk = 0;
		rst = 0;
		T = 0;
		#2 rst = 1; #7 rst = 0;
	end
	
	initial forever #10 clk = ~clk;
	
	initial begin 
		#100;
		
		wrf = $fopen("test/decoded/R.txt", "w");
		
		while (~done[0]) begin
			#20;
			if (valid[0])
				$fwrite(wrf, "%0d,", R);
			if (NR[0])
				$fwrite(wrf, "\n");
		end
			
		$fclose(wrf);
		wrf = 0;		
	end

	initial begin 
		#100;
		
		wgf = $fopen("test/decoded/G.txt", "w");
		
		while (~done[1]) begin
			#20;
			if (valid[1])
				$fwrite(wgf, "%0d,", G);
			if (NR[1])
				$fwrite(wgf, "\n");
		end
			
		$fclose(wgf);
		wgf = 0;		
	end

	initial begin 
		#100;
		
		wbf = $fopen("test/decoded/B.txt", "w");
		
		while (~done[2]) begin
			#20;
			if (valid[2])
				$fwrite(wbf, "%0d,", B);
			if (NR[2])
				$fwrite(wbf, "\n");
		end
			
		$fclose(wbf);
		wbf = 0;		
	end
endmodule

