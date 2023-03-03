// -----------------------------------------------------------------------------
//  Title      : TEST Block
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : test_csr_regs_auto.v
//  Author     : auto-generated
//  Created    : 2023-03-03
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
// This block is the registers of the top level test bench
// -----------------------------------------------------------------------------
//  Copyright (c) 2021 Simon Southwell
// -----------------------------------------------------------------------------
//
//  This is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  It is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this code. If not, see <http://www.gnu.org/licenses/>.
//
// -----------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------
// --------------------- AUTO-GENERATED FILE. DO NOT EDIT ----------------------
// -----------------------------------------------------------------------------

`timescale 1ns / 10ps

`include "test_auto.vh"

module test_csr_regs
  #(parameter
    ADDR_DECODE_WIDTH = 8
  )
  (
    // Clock and reset
    input                          clk,
    input                          rst_n,

    // auto-generated

    // Internal signal ports
    output                control_error,
    output                control_do_stop,
    output                control_do_finish,
    output                control_partial_test,
    output      [30:0]    timeout,
    input       [31:0]    time_count,
    input        [8:0]    config_clk_freq,

    // end auto-generated

    // Slave bus port
    input  [ADDR_DECODE_WIDTH-1:0] avs_address,
    input                          avs_write,
    input  [31:0]                  avs_writedata,
    input                          avs_read,
    output [31:0]                  avs_readdata

  );


  reg [31:0] next_avs_readdata;
  reg [31:0] avs_readdata_reg;

  // auto-generated
  
  reg                control_error_reg;
  reg                control_do_stop_reg;
  reg                control_do_finish_reg;
  reg                control_partial_test_reg;
  reg      [30:0]    timeout_reg;
  reg                next_control_error;
  reg                next_control_do_stop;
  reg                next_control_do_finish;
  reg                next_control_partial_test;
  reg      [30:0]    next_timeout;
  
  // end auto-generated
  
  
  // Export registers interface read data to output port
  assign avs_readdata = avs_readdata_reg;
  
  // auto-generated
  
  // Export internal write registers to output ports
  assign control_error                   = control_error_reg;
  assign control_do_stop                 = control_do_stop_reg;
  assign control_do_finish               = control_do_finish_reg;
  assign control_partial_test            = control_partial_test_reg;
  assign timeout                         = timeout_reg;

  // Export AVS write bus to write pulse register ports
  
  // end auto-generated

  // Process to calculate next state, generate output read/write pulses
  // and write pulse register output
  always @*
  begin
  
    // Default reads to 0. (Allows ORing of busses.)
    next_avs_readdata <= 0;
  
    // auto-generated
  
    // Default the internal write register next values to be current state
    next_control_error                   <= control_error_reg;
    next_control_do_stop                 <= control_do_stop_reg;
    next_control_do_finish               <= control_do_finish_reg;
    next_control_partial_test            <= control_partial_test_reg;
    next_timeout                         <= timeout_reg;
  
    // Default the write-clear register next values to 0
  
    // Default the read- and write-pulse register pulse outputs to 0
  
    // end auto-generated
  
    // Bus write active
    if (avs_write == 1'b1)
    begin
      case (avs_address)
  
        // auto-generated
  
        // Write (and write pulse) register case statements

        `CSR_CONTROL_ADDR :
        begin
          next_control_do_finish         <= avs_writedata[2];
          next_control_do_stop           <= avs_writedata[1];
          next_control_error             <= avs_writedata[0];
          next_control_partial_test      <= avs_writedata[3];
        end

        `CSR_TIMEOUT_ADDR :
        begin
          next_timeout                   <= avs_writedata[30:0];
        end
        
        default:
        begin
            next_avs_readdata <= 32'h0; // Added to make sure not an empty clause
        end
        // end auto-generated
  
      endcase
    end
  
    // Bus read active
    if (avs_read == 1'b1)
    begin
      // Default the next_avs_readdata to 0
      next_avs_readdata <= 32'h0;
  
      case (avs_address)
  
        // auto-generated
  
        // Write and read (incl. constant) case statements

        `CSR_CONFIG_CLK_FREQ_ADDR :
        begin
          next_avs_readdata[8:0]              <= config_clk_freq;
        end

        `CSR_CONTROL_ADDR :
        begin
          next_avs_readdata[2]                <= control_do_finish_reg;
          next_avs_readdata[1]                <= control_do_stop_reg;
          next_avs_readdata[0]                <= control_error_reg;
          next_avs_readdata[3]                <= control_partial_test_reg;
        end

        `CSR_TIME_COUNT_ADDR :
        begin
          next_avs_readdata[31:0]             <= time_count;
        end

        `CSR_TIMEOUT_ADDR :
        begin
          next_avs_readdata[30:0]             <= timeout_reg;
        end
        // end auto-generated
  
        // Default an active read on non-existent register
        default :
          next_avs_readdata <= 32'h0;
  
      endcase
    end
  end
  
  // Process to update internal state
  always @(posedge clk or negedge rst_n)
  begin
    if (rst_n == 1'b0)
    begin
  
      avs_readdata_reg                     <= 32'h0;
  
      // auto-generated
  
      // Reset internal write registers
      control_error_reg                    <= 1'b0;
      control_do_stop_reg                  <= 1'b0;
      control_do_finish_reg                <= 1'b0;
      control_partial_test_reg             <= 1'b0;
      timeout_reg                          <= 31'h00989680;
  
      // end auto-generated
    end
    else
    begin
      avs_readdata_reg                     <= next_avs_readdata;
  
      // auto-generated
  
      // Internal write register state updates
      control_error_reg                    <= next_control_error;
      control_do_stop_reg                  <= next_control_do_stop;
      control_do_finish_reg                <= next_control_do_finish;
      control_partial_test_reg             <= next_control_partial_test;
      timeout_reg                          <= next_timeout;
  
      // end auto-generated
  
    end
  end

endmodule

