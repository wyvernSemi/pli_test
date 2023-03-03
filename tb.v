// -----------------------------------------------------------------------------
//  Title      : VProc based directed test bench top level
// -----------------------------------------------------------------------------
//  File       : tb.v
//  Author     : Simon Southwell
//  Created    : 2023-03-01
//  Platform   :
//  Standard   : Verilog 2001
// -----------------------------------------------------------------------------
//  Description:
//  This block is the top level test bench
// -----------------------------------------------------------------------------
//  Copyright (c) 2023 Simon Southwell
// -----------------------------------------------------------------------------

// --------------------------------------------------------
// Timescale
// --------------------------------------------------------

`timescale                        1ns / 10ps

// --------------------------------------------------------
// Module
// --------------------------------------------------------

module tb
  #(parameter
    GUI_RUN                       = 0,
    CLK_FREQ_MHZ                  = 100
  )
  ( /* no ports */);

// --------------------------------------------------------
// Signal declarations
// --------------------------------------------------------

// Clock signal
wire                              clk_x2;
wire                              clk;
wire                              clk_div2;
wire    [31:0]                    count_vec;
wire    [30:0]                    timeout;
wire                              rst_n;

// AVS
wire    [31:0]                    avs_csr_address;
wire    [31:0]                    avs_csr_writedata;
wire    [31:0]                    avs_csr_readdata ;
wire                              avs_csr_write;
wire                              avs_csr_read;

wire                              avs_csr_write_uut;
wire                              avs_csr_read_uut;
wire    [31:0]                    avs_csr_readdata_uut;

wire                              avs_csr_write_mem;
wire                              avs_csr_read_mem;
wire    [31:0]                    avs_csr_readdata_mem;

wire                              avs_csr_write_tb;
wire                              avs_csr_read_tb;
wire    [31:0]                    avs_csr_readdata_tb;

// Avalon Master read interface from memory model
wire                              avm_rx_waitrequest;
wire    [11:0]                    avm_rx_burstcount;
wire    [31:0]                    avm_rx_address;
wire                              avm_rx_read;
wire    [31:0]                    avm_rx_readdata;
wire                              avm_rx_readdatavalid;

// Avalon Master write interface to memory model
wire                              avm_tx_waitrequest;
wire    [11:0]                    avm_tx_burstcount;
wire    [31:0]                    avm_tx_address;
wire                              avm_tx_write;
wire    [31:0]                    avm_tx_writedata;

// Memory model write port signals
wire                              wr_valid;
wire    [31:0]                    wr_data;
wire    [31:0]                    wr_addr;

// Simuation control and status
wire                              error;
wire                              do_stop;
wire                              do_finish;
wire                              partial_test;
wire                              passed;
wire                              failed;

// --------------------------------------------------------
// Test bench control
// --------------------------------------------------------
  tb_ctrl
  #(
      .GUI_RUN      (GUI_RUN),
      .CLK_FREQ_MHZ (CLK_FREQ_MHZ)
    )
  tb_ctrl_inst (
    // Clock and reset outputs
    .clk                          (clk),
    .clk_div2                     (clk_div2),
    .clk_x2                       (clk_x2),
    .rst_n                        (rst_n),

    .count_vec                    (count_vec),
    .timeout                      ({1'b0, timeout}),

    // Status and control inputs
    .error                        (error),
    .do_stop                      (do_stop),
    .do_finish                    (do_finish),
    .partial_test                 (partial_test),

    // Test condition flags (for inspection externally)
    .failed                       (failed),
    .passed                       (passed)
  );

// --------------------------------------------------------
// Test bench address decode (auto-gen)
// --------------------------------------------------------

  test_csr_decode test_csr_decode_inst
  (
    .uut_write                    (avs_csr_write_uut),
    .uut_read                     (avs_csr_read_uut),
    .uut_readdata                 (avs_csr_readdata_uut),

    .local_write                  (avs_csr_write_tb),
    .local_read                   (avs_csr_read_tb),
    .local_readdata               (avs_csr_readdata_tb),

    .memory_write                 (avs_csr_write_mem),
    .memory_read                  (avs_csr_read_mem),
    .memory_readdata              (avs_csr_readdata_mem),

    .avs_address                  (avs_csr_address[28:24]),
    .avs_write                    (avs_csr_write),
    .avs_read                     (avs_csr_read),
    .avs_readdata                 (avs_csr_readdata)

  );

// --------------------------------------------------------
// Local test bench registers
// --------------------------------------------------------

  test_csr_regs
  #(
    .ADDR_DECODE_WIDTH(5)
  )
  test_csr_regs_inst(
    .clk                          (clk),
    .rst_n                        (rst_n),

    .control_error                (error),
    .control_do_stop              (do_stop),
    .control_do_finish            (do_finish),
    .control_partial_test         (partial_test),

    .config_clk_freq              (CLK_FREQ_MHZ[8:0]),

    .time_count                   (count_vec),
    .timeout                      (timeout),

    .avs_address                  (avs_csr_address[4:0]),
    .avs_write                    (avs_csr_write_tb),
    .avs_writedata                (avs_csr_writedata),
    .avs_read                     (avs_csr_read_tb),
    .avs_readdata                 (avs_csr_readdata_tb)

 );

// --------------------------------------------------------
// Virtual processor with Avalon mem mapped bus BFM
// --------------------------------------------------------

  avmvproc
  #(
    .NODE_NUM                     (0),
    .AUTO_VALID_CSR               (1) // Generate a CSR bus read data valid internally
  )
  avsproc_inst
  (
    .clk                          (clk),
    .rst_n                        (rst_n),

    // Avalon memory mapped master interface
    .avs_csr_address              (avs_csr_address),
    .avs_csr_write                (avs_csr_write),
    .avs_csr_writedata            (avs_csr_writedata),
    .avs_csr_read                 (avs_csr_read),
    .avs_csr_readdata             (avs_csr_readdata),
    .avs_csr_readdatavalid        (),
    .irq                          (1'b0)
  );


// --------------------------------------------------------
// Instantiation of memory model
// --------------------------------------------------------
  mem_model
  #(
    .EN_READ_QUEUE                (1)
  )
  mem_model_inst (
    .clk                          (clk),
    .rst_n                        (rst_n),

    .address                      (avs_csr_address),
    .write                        (avs_csr_write_mem),
    .writedata                    (avs_csr_writedata),
    .byteenable                   (4'b1111),
    .read                         (avs_csr_read_mem),
    .readdata                     (avs_csr_readdata_mem),
    .readdatavalid                (),

    .rx_waitrequest               (avm_rx_waitrequest),
    .rx_burstcount                (avm_rx_burstcount),
    .rx_address                   ({1'b0, avm_rx_address[30:0]}), // Removed ACP bit
    .rx_read                      (avm_rx_read),
    .rx_readdata                  (avm_rx_readdata),
    .rx_readdatavalid             (avm_rx_readdatavalid),

    .tx_waitrequest               (avm_tx_waitrequest),
    .tx_burstcount                (avm_tx_burstcount),
    .tx_address                   (avm_tx_address),
    .tx_write                     (avm_tx_write),
    .tx_writedata                 (avm_tx_writedata),

    .wr_port_valid                (wr_valid),
    .wr_port_data                 (wr_data),
    .wr_port_addr                 (wr_addr)

  );

// Write port unused
assign wr_valid                   = 1'b0;

// --------------------------------------------------------
// Instantiation of UUT
// ---------------------------------------------------------

  uut uut_inst (
    .clk                          (clk),
    .rst_n                        (rst_n),
    
    .avs_csr_address              (avs_csr_address[4:0]),
    .avs_csr_write                (avs_csr_write_uut),
    .avs_csr_writedata            (avs_csr_writedata),
    .avs_csr_read                 (avs_csr_read_uut),
    .avs_csr_readdata             (avs_csr_readdata_uut),
    
    .avm_rx_waitrequest           (avm_rx_waitrequest),
    .avm_rx_burstcount            (avm_rx_burstcount),
    .avm_rx_address               (avm_rx_address),
    .avm_rx_read                  (avm_rx_read),
    .avm_rx_readdata              (avm_rx_readdata),
    .avm_rx_readdatavalid         (avm_rx_readdatavalid),
    
    .avm_tx_waitrequest           (avm_tx_waitrequest),
    .avm_tx_burstcount            (avm_tx_burstcount),
    .avm_tx_address               (avm_tx_address),
    .avm_tx_write                 (avm_tx_write),
    .avm_tx_writedata             (avm_tx_writedata)
  );

endmodule
