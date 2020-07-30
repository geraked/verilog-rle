`timescale 1ns / 1ps

module Top(clk, rst, T, valid, NR, done, R, G, B);
	input clk, rst;
	input [7:0] T;
	output [2:0] valid, NR, done;
	output [7:0] R, G, B;
	
	wire [15:0] rle_rcode, rle_gcode, rle_bcode;
	
	wire tx_rcode_start, tx_gcode_start, tx_bcode_start;
	wire tx_rcode_dout, tx_gcode_dout, tx_bcode_dout;
	wire rx_rcode_done, rx_gcode_done, rx_bcode_done;
	wire [15:0] rx_rcode, rx_gcode, rx_bcode;
	
	wire [2:0] rld_start;
	
	RLE_Set Top_RLE_set (
		.clk(clk),
		.rst(rst),
		.T(T),
		.done(),
		.R_code(rle_rcode),
		.G_code(rle_gcode),
		.B_code(rle_bcode)
	);
	// 435 clks per bit
	// each code is 16 bit
	// 1 bit start 1 bit stop
	// 435 * 18 = 7830 clk per code	
	defparam Top_RLE_set.HOLD_CLK = 7830;
	
	
	uart_tx Top_uart_tx_rcode (
		.clk(clk),
		.din(rle_rcode),
		.start(tx_rcode_start),
		.dout(tx_rcode_dout),
		.active(),
		.done()
	);

	uart_tx Top_uart_tx_gcode (
		.clk(clk),
		.din(rle_gcode),
		.start(tx_gcode_start),
		.dout(tx_gcode_dout),
		.active(),
		.done()
	);

	uart_tx Top_uart_tx_bcode (
		.clk(clk),
		.din(rle_bcode),
		.start(tx_bcode_start),
		.dout(tx_bcode_dout),
		.active(),
		.done()
	);	
	
	
	uart_rx Top_uart_rx_rcode (
		.clk(clk),
		.din(tx_rcode_dout),
		.dout(rx_rcode),
		.done(rx_rcode_done)
	);

	uart_rx Top_uart_rx_gcode (
		.clk(clk),
		.din(tx_gcode_dout),
		.dout(rx_gcode),
		.done(rx_gcode_done)
	);
	
	uart_rx Top_uart_rx_bcode (
		.clk(clk),
		.din(tx_bcode_dout),
		.dout(rx_bcode),
		.done(rx_bcode_done)
	);
	
	
	RLD Top_RLD (
		.clk(clk),
		.rst(rst),
		.NR(NR),
		.valid(valid),
		.done(done),
		.start(rld_start),
		.R_code(rx_rcode),
		.G_code(rx_gcode),
		.B_code(rx_bcode),
		.R(R),
		.G(G),
		.B(B)
	);
	
	assign rld_start = {rx_bcode_done, rx_gcode_done, rx_rcode_done}; 
	
	assign tx_rcode_start = (rle_rcode == 0) ? 0 : 1;
	assign tx_gcode_start = (rle_gcode == 0) ? 0 : 1;
	assign tx_bcode_start = (rle_bcode == 0) ? 0 : 1;
endmodule
