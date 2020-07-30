`timescale 1ns / 1ns

module RLD_tb;
	reg rst, clk;
	reg [2:0] start;
	reg [15:0] R_code, G_code, B_code;

	wire [7:0] R, G, B;
	wire [2:0] valid, NR, done;
	
	integer rrf, rgf, rbf;
	integer wrf, wgf, wbf;

	RLD uut (
		.rst(rst), 
		.clk(clk), 
		.start(start), 
		.R_code(R_code), 
		.G_code(G_code), 
		.B_code(B_code), 
		.R(R), 
		.G(G), 
		.B(B), 
		.done(done),
		.valid(valid),
		.NR(NR)
	);

	initial begin
		rst = 0;
		clk = 0;
		start = 0;
		R_code = 0;
		G_code = 0;
		B_code = 0;
		#2 rst = 1; #7 rst = 0;
	end
	
	initial forever #10 clk = ~clk;
	
	initial begin 
		#100;
		
		rrf = $fopen("test/encoded/R.txt", "r");
		$fscanf(rrf, "%d,", R_code);
		start[0] = 1;
		#20;
		start[0] = 0;		
		
		while (~R_code && ~done[0]) begin
			#600;
			$fscanf(rrf, "%d,", R_code);
			start[0] = 1;
			#20;
			start[0] = 0;
		end
			
		$fclose(rrf);
		rrf = 0;		
	end
	
	initial begin 
		#100;
		
		rgf = $fopen("test/encoded/G.txt", "r");
		$fscanf(rgf, "%d,", G_code);
		start[1] = 1;
		#20;
		start[1] = 0;		
		
		while (~G_code && ~done[1]) begin
			#600;
			$fscanf(rgf, "%d,", G_code);
			start[1] = 1;
			#20;
			start[1] = 0;
		end
			
		$fclose(rgf);
		rgf = 0;		
	end

	initial begin 
		#100;
		
		rbf = $fopen("test/encoded/B.txt", "r");
		$fscanf(rbf, "%d,", B_code);
		start[2] = 1;
		#20;
		start[2] = 0;		
		
		while (~B_code && ~done[2]) begin
			#600;
			$fscanf(rbf, "%d,", B_code);
			start[2] = 1;
			#20;
			start[2] = 0;
		end
			
		$fclose(rbf);
		rbf = 0;		
	end	

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
