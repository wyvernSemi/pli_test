// -----------------------------------------------------------------------------
//  Title      : UUT Block
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : uut_csr_regs_auto.v
//  Author     : auto-generated
//  Created    : 2023-03-03
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
// This block is the registers for the UUT 
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

`include "uut_auto.vh"

module uut_csr_regs
  #(parameter
    ADDR_DECODE_WIDTH = 8
  )
  (
    // Clock and reset
    input                          clk,
    input                          rst_n,

    // auto-generated

    // Internal signal ports
    output      [13:2]    control_length,
    output      [31:0]    baseaddr,
    output                control_startwr,
    output                control_startrd,
    output                control_clrerr,
    input                 status_busy,
    input                 status_error,

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
  
  reg      [13:2]    control_length_reg;
  reg      [31:0]    baseaddr_reg;
  reg                control_startwr_reg;
  reg                control_startrd_reg;
  reg                control_clrerr_reg;
  reg      [13:2]    next_control_length;
  reg      [31:0]    next_baseaddr;
  reg                next_control_startwr;
  reg                next_control_startrd;
  reg                next_control_clrerr;
  
  // end auto-generated
  
  
  // Export registers interface read data to output port
  assign avs_readdata = avs_readdata_reg;
  
  // auto-generated
  
  // Export internal write registers to output ports
  assign control_length                  = control_length_reg;
  assign baseaddr                        = baseaddr_reg;
  assign control_startwr                 = control_startwr_reg;
  assign control_startrd                 = control_startrd_reg;
  assign control_clrerr                  = control_clrerr_reg;

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
    next_control_length                  <= control_length_reg;
    next_baseaddr                        <= baseaddr_reg;
  
    // Default the write-clear register next values to 0
    next_control_startwr                 <= 1'b0;
    next_control_startrd                 <= 1'b0;
    next_control_clrerr                  <= 1'b0;
  
    // Default the read- and write-pulse register pulse outputs to 0
  
    // end auto-generated
  
    // Bus write active
    if (avs_write == 1'b1)
    begin
      case (avs_address)
  
        // auto-generated
  
        // Write (and write pulse) register case statements

        `CSR_BASEADDR_ADDR :
        begin
          next_baseaddr                  <= avs_writedata[31:0];
        end

        `CSR_CONTROL_ADDR :
        begin
          next_control_clrerr            <= avs_writedata[14];
          next_control_length            <= avs_writedata[13:2];
          next_control_startrd           <= avs_writedata[1];
          next_control_startwr           <= avs_writedata[0];
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

        `CSR_BASEADDR_ADDR :
        begin
          next_avs_readdata[31:0]             <= baseaddr_reg;
        end

        `CSR_CONTROL_ADDR :
        begin
          next_avs_readdata[13:2]             <= control_length_reg;
        end

        `CSR_STATUS_ADDR :
        begin
          next_avs_readdata[0]                <= status_busy;
          next_avs_readdata[1]                <= status_error;
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
      control_length_reg                   <= 12'h0;
      baseaddr_reg                         <= 32'h0;
      control_startwr_reg                  <= 1'b0;
      control_startrd_reg                  <= 1'b0;
      control_clrerr_reg                   <= 1'b0;
  
      // end auto-generated
    end
    else
    begin
      avs_readdata_reg                     <= next_avs_readdata;
  
      // auto-generated
  
      // Internal write register state updates
      control_length_reg                   <= next_control_length;
      baseaddr_reg                         <= next_baseaddr;
      control_startwr_reg                  <= next_control_startwr;
      control_startrd_reg                  <= next_control_startrd;
      control_clrerr_reg                   <= next_control_clrerr;
  
      // end auto-generated
  
    end
  end

endmodule

