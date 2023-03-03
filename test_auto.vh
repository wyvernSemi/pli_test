// Block name: test
// And now for some register addresses...
`define CSR_UUT_ADDR                        32'h00000000
`define CSR_UUT_ADDR_INT                    0
`define CSR_MEMORY_ADDR                     32'h08000000
`define CSR_MEMORY_ADDR_INT                 134217728
`define CSR_LOCAL_ADDR                      32'h18000000
`define CSR_LOCAL_ADDR_INT                  402653184

`define CSR_CONTROL_ADDR                     5'h00
`define CSR_CONTROL_ADDR_INT                 0
`define CSR_CONTROL_ERROR                    0:0
`define CSR_CONTROL_DO_STOP                  1:1
`define CSR_CONTROL_DO_FINISH                2:2
`define CSR_CONTROL_PARTIAL_TEST             3:3
`define CSR_TIME_COUNT_ADDR                  5'h01
`define CSR_TIME_COUNT_ADDR_INT              1
`define CSR_TIMEOUT_ADDR                     5'h02
`define CSR_TIMEOUT_ADDR_INT                 2
`define CSR_CONFIG_CLK_FREQ_ADDR             5'h03
`define CSR_CONFIG_CLK_FREQ_ADDR_INT         3

