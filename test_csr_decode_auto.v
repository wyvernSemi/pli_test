// -----------------------------------------------------------------------------
//  Title      : TEST Block
//  Project    : UNKNOWN
// -----------------------------------------------------------------------------
//  File       : test_csr_decode_auto.v
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

module test_csr_decode 
  #(parameter
    ADDR_DECODE_HI_BIT = 28,
    ADDR_DECODE_LO_BIT = 24
  )
  (
  
    // auto-generated
    
    // Decoded read/write strobes and returned read data
    output reg        uut_write,
    output reg        uut_read,
    input      [31:0] uut_readdata,
    output reg        memory_write,
    output reg        memory_read,
    input      [31:0] memory_readdata,
    output reg        local_write,
    output reg        local_read,
    input      [31:0] local_readdata,
    
    // end auto-generated
    
    // Avalon CSR slave interface
    input      [ADDR_DECODE_HI_BIT:ADDR_DECODE_LO_BIT] avs_address,
    input                                              avs_write,
    input                                              avs_read,
    output     [31:0]                                  avs_readdata
    
  );

  // auto-generated
  assign avs_readdata = uut_readdata | memory_readdata | local_readdata;
  // end auto-generated

  always @* 
  begin
    // auto-generated
    
    uut_write                      <= 1'b0;
    uut_read                       <= 1'b0;
    memory_write                   <= 1'b0;
    memory_read                    <= 1'b0;
    local_write                    <= 1'b0;
    local_read                     <= 1'b0;

    case (avs_address)
    
    5'd0 :
    begin
        uut_write                  <= avs_write;
        uut_read                   <= avs_read;
    end

    5'd8 :
    begin
        memory_write               <= avs_write;
        memory_read                <= avs_read;
    end

    5'd24 :
    begin
        local_write                <= avs_write;
        local_read                 <= avs_read;
    end


    endcase
    
    // end auto-generated
  end
  
endmodule