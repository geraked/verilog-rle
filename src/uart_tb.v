`timescale 1ns/10ps
 
module uart_tb ();
 
  // Testbench uses a 50 MHz clock
  // Want to interface to 115200 baud UART
  // 50000000 / 115200 = 435 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 20;
  parameter c_CLKS_PER_BIT    = 435;
  parameter c_BIT_PERIOD      = 8700;
   
  reg  r_Clock = 0;
  reg  r_Tx_DV = 0;
  wire w_Tx_Done;
  reg  [15:0] r_Tx_Byte = 0;
  reg  r_Rx_Serial = 1;
  wire [15:0] w_Rx_Byte;
   
 
  // Takes in input byte and serializes it 
  task UART_WRITE_BYTE;
    input   [15:0] i_Data;
    integer        ii;
    begin
       
      // Send Start Bit
      r_Rx_Serial <= 1'b0;
      #(c_BIT_PERIOD);
      #1000;
       
       
      // Send Data Byte
      for (ii=0; ii<16; ii=ii+1)
        begin
          r_Rx_Serial <= i_Data[ii];
          #(c_BIT_PERIOD);
        end
       
      // Send Stop Bit
      r_Rx_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE
   
   
  uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
    (.clk(r_Clock),
     .din(r_Rx_Serial),
     .done(),
     .dout(w_Rx_Byte)
     );
   
  uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
    (.clk(r_Clock),
     .start(r_Tx_DV),
     .din(r_Tx_Byte),
     .active(),
     .dout(),
     .done(w_Tx_Done)
     );
 
   
  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;
 
   
  // Main Testing:
  initial
    begin
       
      // Tell UART to send a command (exercise Tx)
      @(posedge r_Clock);
      @(posedge r_Clock);
      r_Tx_DV <= 1'b1;
      r_Tx_Byte <= 16'hAB;
      @(posedge r_Clock);
      r_Tx_DV <= 1'b0;
      @(posedge w_Tx_Done);
       
      // Send a command to the UART (exercise Rx)
      @(posedge r_Clock);
      UART_WRITE_BYTE(16'h3F);
      @(posedge r_Clock);
             
      // Check that the correct command was received
      if (w_Rx_Byte == 16'h3F)
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
       
    end
   
endmodule
