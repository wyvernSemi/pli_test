// Block name: uut
// And now for some register addresses...
`define CSR_CONTROL_ADDR                     5'h00
`define CSR_CONTROL_ADDR_INT                 0
`define CSR_CONTROL_STARTWR                  0:0
`define CSR_CONTROL_STARTRD                  1:1
`define CSR_CONTROL_LENGTH                   13:2
`define CSR_CONTROL_CLRERR                   14:14
`define CSR_STATUS_ADDR                      5'h01
`define CSR_STATUS_ADDR_INT                  1
`define CSR_STATUS_BUSY                      0:0
`define CSR_STATUS_ERROR                     1:1
`define CSR_BASEADDR_ADDR                    5'h02
`define CSR_BASEADDR_ADDR_INT                2

