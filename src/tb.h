/**************************************************************/
/* tb.h                                      Date: 2023/03/01 */
/*                                                            */
/* Copyright (c) 2023 Simon Southwell. All rights reserved.   */
/*                                                            */
/**************************************************************/

#include <stdio.h>
#include <stdlib.h>

#ifndef _TB_H_
#define _TB_H_

// Address of physical memory where output data starts
#define START_PHY_MEM                           0x20000000

#define MEM_BASE_ADDR                           START_PHY_MEM

// Test bench address for local registers
#define TB_BASE_ADDR                            0x60000000
#define TB_SIM_CTRL_REG                         (TB_BASE_ADDR + 0)
#define TB_CAPTURE_ADDR                         (TB_BASE_ADDR + 4)
#define TB_IMG_WIDTH_PX                         (TB_BASE_ADDR + 8)

#define TB_SIM_CTRL_ERROR_MASK                  0x00000001
#define TB_SIM_CTRL_STOP_MASK                   0x00000002
#define TB_SIM_CTRL_FINISH_MASK                 0x00000004

#define TEST_ERROR                              1
#define NOERROR                                 0

extern void     usleepSim       (unsigned time);
extern void     nsleepSim       (unsigned time);
extern void     directWriteMem  (uint32_t addr, uint32_t  data);
extern uint32_t directReadMem   (uint32_t addr, uint32_t* data);

#endif
