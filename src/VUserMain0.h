/**************************************************************/
/* VUserMain.h                               Date: 2023/03/01 */
/*                                                            */
/* Copyright (c) 2023 Simopn Southwell. All rights reserved.  */
/*                                                            */
/**************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#ifndef _VUSERMAIN0_H_
#define _VUSERMAIN0_H_

extern "C" {
#include "VUser.h"
}

// Define VProc call normal and delta values
#define NORMAL_UPDATE                           0
#define DELTA_UPDATE                            1

// Define a sensible time for a register access, in clock cycles
// Note that for the AVS BFM, the actual length is AVS_ACCESS_LEN + 2
//#define AVS_ACCESS_LEN                          10
#define AVS_ACCESS_LEN                          2

// In simulation the base address for the register bus is 0
#define CORE_BASE_ADDR                          0x00000000

// Define a sleep forever macro
#define SLEEP_FOREVER {while(1)           VTick(0x7fffffff, node);}    

// Exported library functions that aim to virtualise away VProc details
void     stopSim        (bool     error);
void     finishSim      (int      error);
void     usleepSim      (unsigned time);
void     nsleepSim      (unsigned time);

uint32_t csrReadMem     (uint32_t addr, uint32_t* data);
void     csrWriteMem    (uint32_t addr, uint32_t  data);
uint32_t directReadMem  (uint32_t addr, uint32_t* data);
void     directWriteMem (uint32_t addr, uint32_t  data);

// Used by auto-generated HAL
extern "C" uint32_t read_ext       (uint32_t addr, uint32_t* data);
extern "C" void     write_ext      (uint32_t addr, uint32_t  data);

#endif