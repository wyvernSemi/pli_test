// Block name: test, using byte offsets

#include <stdint.h>

#ifndef __TEST_H__
#define __TEST_H__

#define CSR_TEST_UUT                                  0x00000000
#define CSR_TEST_MEMORY                               0x20000000
#define CSR_TEST_LOCAL                                0x60000000
#define CSR_TEST_CONTROL                              0x00000000
#define CSR_TEST_CONTROL_ERROR                        0
#define CSR_TEST_CONTROL_ERROR_WIDTH                  1
#define CSR_TEST_CONTROL_ERROR_MASK                   0x00000001
#define CSR_TEST_CONTROL_DO_STOP                      1
#define CSR_TEST_CONTROL_DO_STOP_WIDTH                1
#define CSR_TEST_CONTROL_DO_STOP_MASK                 0x00000002
#define CSR_TEST_CONTROL_DO_FINISH                    2
#define CSR_TEST_CONTROL_DO_FINISH_WIDTH              1
#define CSR_TEST_CONTROL_DO_FINISH_MASK               0x00000004
#define CSR_TEST_CONTROL_PARTIAL_TEST                 3
#define CSR_TEST_CONTROL_PARTIAL_TEST_WIDTH           1
#define CSR_TEST_CONTROL_PARTIAL_TEST_MASK            0x00000008

#define CSR_TEST_TIME_COUNT                           0x00000004

#define CSR_TEST_TIMEOUT                              0x00000008

#define CSR_TEST_CONFIG_CLK_FREQ                      0x0000000c


#endif
