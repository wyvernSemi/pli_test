// -----------------------------------------------------------------------------
//  Title      : UUT stand in for demonstration
// -----------------------------------------------------------------------------
//  File       : tb.v
//  Author     : Simon Southwell
//  Created    : 2023-03-01
//  Platform   :
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//    This block is a UUT stand in for demonstration of VProc and mem_model
// -----------------------------------------------------------------------------
//  Copyright (c) 2023 Simon Southwell
// -----------------------------------------------------------------------------

`timescale 1ns / 10ps

module uut (
    input                         clk,
    input                         rst_n,

    input       [4:0]             avs_csr_address,
    input                         avs_csr_write,
    input      [31:0]             avs_csr_writedata,
    input                         avs_csr_read,
    output     [31:0]             avs_csr_readdata,

    input                         avm_rx_waitrequest,
    output     [11:0]             avm_rx_burstcount,
    output     [31:0]             avm_rx_address,
    output reg                    avm_rx_read,
    input      [31:0]             avm_rx_readdata,
    input                         avm_rx_readdatavalid,

    input                         avm_tx_waitrequest,
    output     [11:0]             avm_tx_burstcount,
    output     [31:0]             avm_tx_address,
    output reg                    avm_tx_write,
    output     [31:0]             avm_tx_writedata
  );

wire           [11:0]             length;
wire           [31:0]             baseaddr;
wire                              startwr;
wire                              startrd;
wire                              clrerr;

reg                               busy;
reg                               rnw;
reg                               error;
reg            [11:0]             count;

reg            [31:0]             mem [0:4095];

function int isNoise;
input [7:0] val;
begin
  if (val == 8'h0a ||
      val == 8'h27 ||
      val == 8'h28 ||
      val == 8'h29 ||
      val == 8'h2c ||
      val == 8'h2f ||
      val == 8'h3c ||
      val == 8'h5c ||
      val == 8'h5f ||
      val == 8'h60 ||
      val == 8'h7c)
    return 0;
  else
    return 1;
end
endfunction

// --------------------------------------------------------
// Signal assignments
// --------------------------------------------------------

assign avm_tx_address             = avm_tx_write ? baseaddr     : 32'hx;
assign avm_tx_burstcount          = length;
assign avm_tx_writedata           = ~rnw         ? mem_rd       : 32'hx;

assign avm_rx_address             = avm_rx_read  ? baseaddr     : 32'hx;
assign avm_rx_burstcount          = length;

wire [31:0] mem_rd = {isNoise(mem[memaddr][31:24]) ? 8'h20 : mem[memaddr][31:24],
                      isNoise(mem[memaddr][23:16]) ? 8'h20 : mem[memaddr][23:16],
                      isNoise(mem[memaddr][15: 8]) ? 8'h20 : mem[memaddr][15: 8],
                      isNoise(mem[memaddr][ 7: 0]) ? 8'h20 : mem[memaddr][ 7:0]};

// -------------------------------------------------------
// Control process
// -------------------------------------------------------

always @(posedge clk, negedge rst_n)
begin
  if (rst_n == 1'b0)
  begin
    busy                          <= 1'b0;
    rnw                           <= 1'b0;
    error                         <= 1'b0;
    count                         <= 32'h0;
    avm_rx_read                   <= 1'b0;
    avm_tx_write                  <= 1'b0;
  end
  else
  begin
    // Hold read strobes if wait request active
    avm_rx_read                   <= avm_rx_read  & avm_rx_waitrequest;

    // Hold error state unless clear error asserted
    error                         <= error & ~clrerr;

    // Instigation of new transfer...
    if (startwr || startrd)
    begin
      // Only start new transfer if not busy and not in error state
      if (~busy && ~error)
      begin
        busy                      <= 1'b1;
        avm_rx_read               <= startrd;
        avm_tx_write              <= startwr;
        rnw                       <= startrd;
        count                     <= length;
      end
      // It's an error to attempt to start new transfer when busy
      else
      begin
        error                     <= 1'b1;
      end
    end

    // Decrement the count when not zero and read data arrives or every tick when writing
    if (count != 32'h0 && (avm_rx_readdatavalid || (avm_tx_write & ~avm_tx_waitrequest)))
    begin
      count                       <= count - 32'h1;

      // On the last decrement, clear the busy state
      if (count == 32'h1)
      begin
        busy                      <= 1'b0;
        avm_tx_write              <= 1'b0;
      end
    end
  end
end

// -------------------------------------------------------
// Internal memory buffer (4K words, the max burst size)
// -------------------------------------------------------

wire [11:0] memaddr = length - count;

always @(posedge clk)
begin
   if (avm_rx_readdatavalid)
   begin
     mem[memaddr]                 <= avm_rx_readdata;
   end
end

// --------------------------------------------------------
// UUT control and status register block
// --------------------------------------------------------
  uut_csr_regs
  #(
    .ADDR_DECODE_WIDTH            (5)
  )
  uut_csr_regs_inst
  (
    // Clock and reset
    .clk                          (clk),
    .rst_n                        (rst_n),

    // Slave bus port
    .avs_address                  (avs_csr_address),
    .avs_write                    (avs_csr_write),
    .avs_writedata                (avs_csr_writedata),
    .avs_read                     (avs_csr_read),
    .avs_readdata                 (avs_csr_readdata),

    // Control and status signals
    .control_length               (length),
    .baseaddr                     (baseaddr),
    .control_startwr              (startwr),
    .control_startrd              (startrd),
    .control_clrerr               (clrerr),
    .status_busy                  (busy),
    .status_error                 (error)
  );

endmodule