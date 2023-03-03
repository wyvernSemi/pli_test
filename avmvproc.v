// -----------------------------------------------------------------------------
//  Title      : Avalon VProc wrapper
// -----------------------------------------------------------------------------
//  File       : avmproc.v
//  Author     : Simon Southwell
//  Created    : 2023-03-01
//  Platform   :
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//   Virtual processor with Avalon memory mapped master BFM, based on VProc
//   co-simulation element.
// -----------------------------------------------------------------------------
//  Copyright (c) 2023 Simon Southwell
// -----------------------------------------------------------------------------

// --------------------------------------------------------
// Timescale
// --------------------------------------------------------

`timescale                             1ns / 10ps

// --------------------------------------------------------
// Module
// --------------------------------------------------------

module avmvproc
  # (parameter
    NODE_NUM        = 0,
    AUTO_VALID_CSR  = 0
  )
  (
  input                            clk,
  input                            rst_n,

  // Avalon memory mapped master interface
  output [31:0]                    avs_csr_address,
  output                           avs_csr_write,
  output [31:0]                    avs_csr_writedata,
  output                           avs_csr_read,
  input  [31:0]                    avs_csr_readdata,
  input                            avs_csr_readdatavalid,

  // Interrupt
  input                            irq
  );


// Signals for VProc
wire                               update;
wire                               RD;
reg                                RDLast;
wire    [31:0]                     Addr;
wire                               WE;
wire    [31:0]                     DataOut;
wire    [31:0]                     DataIn;
wire                               RDAck;

// Avalon  bus protocol signals
wire                               avs_read;

wire                               avs_csr_readdatavalid_int;
reg                                avs_csr_readdatavalid_reg;

// --------------------------------------------------------
// If auto-generation of read valid for CSR bus is
// selected, generate in cycle after avs_csr_read
// --------------------------------------------------------
generate
  if (AUTO_VALID_CSR)
  begin
    // Generate a read data valid for the CSR bus, as the UUT does not do so
    always @(posedge clk , negedge rst_n)
    begin
      if (rst_n == 1'b0)
      begin
        avs_csr_readdatavalid_reg        <= 1'b0;
      end
      else
      begin
        avs_csr_readdatavalid_reg        <= 1'b0;
        if (avs_csr_read == 1'b1)
        begin
          avs_csr_readdatavalid_reg      <= 1'b1;
        end
      end
    end
  end
endgenerate

// --------------------------------------------------------
// Signal assignments
// --------------------------------------------------------

// Select actual read data value to use internally dependent on AUTO_VALID_CSR
assign avs_csr_readdatavalid_int = AUTO_VALID_CSR ? avs_csr_readdatavalid_reg : avs_csr_readdatavalid;

// Export Avalon CSR bus signals
assign avs_csr_read             = avs_read;
assign avs_csr_write            = WE;
assign avs_csr_writedata        = DataOut;
assign avs_csr_address          = {2'b00, Addr[31:2]};

// Import Avalon CSR bus signals
assign DataIn                   = avs_csr_readdata;
assign RDAck                    = avs_csr_readdatavalid_int;

// Pulse the AVS read signal only for the first cycles of RD, which won't be
// deasserted until the RDAck/avs_readdatavalid is returned.
assign avs_read                 = RD & ~RDLast;

// --------------------------------------------------------
// Generate a delayed version of the RD
// output of VProc
// --------------------------------------------------------
always @(posedge clk, negedge rst_n)
begin
  if (rst_n == 1'b0)
    RDLast   <= 1'b0;
  else
    RDLast   <= RD;
end

// --------------------------------------------------------
//  VProc instantiation
// --------------------------------------------------------

  VProc vproc_inst
  (
      .Clk            (clk),
      .Addr           (Addr),
      .WE             (WE),
      .RD             (RD),
      .DataOut        (DataOut),
      .DataIn         (DataIn),
      .WRAck          (WE),
      .RDAck          (RDAck),
      .Interrupt      ({2'b00, irq}),
      .Update         (update),
      .UpdateResponse (update),
      .Node           (NODE_NUM[3:0])
    );

endmodule
