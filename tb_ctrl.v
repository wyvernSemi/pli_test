// -----------------------------------------------------------------------------
//  Title      : Core directed test bench control
// -----------------------------------------------------------------------------
//  File       : tb.v
//  Author     : Simon Southwell
//  Created    : 2023-03-01
//  Platform   :
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block is test bench control block
// -----------------------------------------------------------------------------
//  Copyright (c) 2023 Simon Southwell
// -----------------------------------------------------------------------------

`timescale 1ns / 10ps

`include "test_auto.vh"

module tb_ctrl
  #(parameter
    GUI_RUN      = 0,
    CLK_FREQ_MHZ = 200,
    RESET_PERIOD = 10
  )
 (

  // Clock and reset outputs
  output  reg         clk_x2,
  output  reg         clk,
  output  reg         clk_div2,
  output              rst_n,
  
  output [31:0]       count_vec,
  input  [31:0]       timeout,
  
  // Simulation status and control inputs
  input               error,
  input               do_stop,
  input               do_finish,
  input               partial_test,
  
  // External end-of-simulation flags
  output              failed,
  output              passed
  
);

// --------------------------------------------------------
// Internal signals
// --------------------------------------------------------

integer               count;
reg                   is_gui_run;
wire                  end_sim;

// --------------------------------------------------------
// Initialise block
// --------------------------------------------------------
initial
begin
  clk_x2              <= 1'b1;
  clk                 <= 1'b0;
  clk_div2            <= 1'b0;
  count               <= 0;  
end

// --------------------------------------------------------
// Generate clocks based on parameter
// --------------------------------------------------------

// Generate x2 clock
always #((1000.0/(2.0*CLK_FREQ_MHZ))/2.0)
  clk_x2              <= ~clk_x2;

// Derive system clock from master clock
always @(posedge clk_x2)
begin
  clk                 <= ~clk;
end

// Derive half speed clock from system clock
always @(posedge clk)
begin
    clk_div2          <= ~clk_div2;
end

// --------------------------------------------------------
// Generate a reset signal using count
// --------------------------------------------------------

assign rst_n          = (count >= RESET_PERIOD) ? 1'b1 : 1'b0;

// --------------------------------------------------------
// Signal assignments
// --------------------------------------------------------

// Export counter
assign count_vec      = count;
  
// End-of-simulation signals
assign end_sim        = (count == timeout || do_stop == 1'b1 || do_finish == 1'b1) ? 1'b1 : 1'b0;
assign failed         = (end_sim == 1'b1 && (error == 1'b1 || count == timeout))   ? 1'b1 : 1'b0;
assign passed         = (end_sim == 1'b1 && error == 1'b0)                         ? 1'b1 : 1'b0;
  
// --------------------------------------------------------
//  Simulation control from VProc over CSR bus
// --------------------------------------------------------

// Set a flag that this is a GUI simulation if the generic GUI_RUN set to 'true' externally
assign is_gui_run     = (GUI_RUN != 0) ? 1'b0 : 1'b1;

// Increment the counter on every system clock 
always @(posedge clk)
begin
  count <= count + 1;
end

// --------------------------------------------------------
// Simulation control process
// --------------------------------------------------------

always @(posedge clk or negedge rst_n)
begin

  if (rst_n == 1'b0)
  begin

  end
  else
  begin

    //---------------------------------------
    // End or stop simulation
    //---------------------------------------

    // If end of simulation, stop
    if (end_sim == 1'b1)
    begin

      if (error == 1'b1)
      begin
          $display("*** FAIL: errors found");
      end
      else
      begin
         if (count >= timeout)
         begin
           $display("*** FAIL: timeout");
         end
         else if (partial_test == 1'b1)
         begin
           $display("NO FAILURES");
         end
         else
         begin
           $display("SUCCESS");
         end
      end
      
      if (is_gui_run == 1'b1 || (do_stop == 1'b1 && do_finish == 1'b0))
        $stop;
      else
        $finish;
    end
  end
end

endmodule