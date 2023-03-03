// Block name: uut, using byte offsets
//   Offset in test for bus csr : 0x00000000

#include <stdint.h>

#ifndef __UUT_H__
#define __UUT_H__

#define CSR_UUT_CONTROL                               0x00000000
#define CSR_UUT_CONTROL_STARTWR                       0
#define CSR_UUT_CONTROL_STARTWR_WIDTH                 1
#define CSR_UUT_CONTROL_STARTWR_MASK                  0x00000001
#define CSR_UUT_CONTROL_STARTRD                       1
#define CSR_UUT_CONTROL_STARTRD_WIDTH                 1
#define CSR_UUT_CONTROL_STARTRD_MASK                  0x00000002
#define CSR_UUT_CONTROL_LENGTH                        2
#define CSR_UUT_CONTROL_LENGTH_WIDTH                  12
#define CSR_UUT_CONTROL_LENGTH_MASK                   0x00003ffc
#define CSR_UUT_CONTROL_CLRERR                        14
#define CSR_UUT_CONTROL_CLRERR_WIDTH                  1
#define CSR_UUT_CONTROL_CLRERR_MASK                   0x00004000

#define CSR_UUT_STATUS                                0x00000004
#define CSR_UUT_STATUS_BUSY                           0
#define CSR_UUT_STATUS_BUSY_WIDTH                     1
#define CSR_UUT_STATUS_BUSY_MASK                      0x00000001
#define CSR_UUT_STATUS_ERROR                          1
#define CSR_UUT_STATUS_ERROR_WIDTH                    1
#define CSR_UUT_STATUS_ERROR_MASK                     0x00000002

#define CSR_UUT_BASEADDR                              0x00000008


#endif
