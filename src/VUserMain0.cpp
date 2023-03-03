/**************************************************************/
/* VUserMain.cpp                             Date: 2023/03/01 */
/*                                                            */
/* Copyright (c) 2023 Simon Southwell. All rights reserved.   */
/*                                                            */
/**************************************************************/

// --------------------------------------------------
// INCLUDES
// --------------------------------------------------
#include <string.h>

#include "VUserMain0.h"
#include "tb.h"
#include "hal/CTestAuto.h"
#include "uutTest.h"

// Access to memory model's direct API (C linkage)
extern "C" {
#include "mem_model.h"
}

//######################################################
//# Add test code includes here
//######################################################

//#define DEBUG

// --------------------------------------------------
// DEFINES
// --------------------------------------------------

#define MAINTESTNUM            0
#define ALIVE_TEST_NUM         0x12345678
#define ALIVE_TEST_OFFSET      0x1000

// --------------------------------------------------
// STATIC VARIABLES
// --------------------------------------------------
// I'm node 0
static int node           = 0;


// This must match the test bench system clock period to get accurate sleep times in the software.
static int sysClkPeriodPs = 10000;
// --------------------------------------------------
// Hooks for auto-generated HAL
// --------------------------------------------------

uint32_t read_ext (uint32_t addr, uint32_t* data)
{
    return csrReadMem(addr, data);
}

void write_ext (uint32_t addr, uint32_t data)
{
    csrWriteMem(addr, data);
}

// --------------------------------------------------
// Read function to access memory over CSR bus
// --------------------------------------------------
uint32_t csrReadMem (uint32_t addr, uint32_t* data)
{
    uint32_t rdata;
    
    // Read over the AVS bus
    VRead(addr, &rdata, NORMAL_UPDATE, node);
    
    *data = rdata;
    
    // Model some access rate time
    VTick(AVS_ACCESS_LEN, node);

#ifdef DEBUG
    VPrint("csrReadMem : addr = 0x%08x data = 0x%08x\n", addr, *data); fflush(NULL);
#endif
    return 0;
}

// --------------------------------------------------
// Write function to access memory over CSR bus
// --------------------------------------------------
void csrWriteMem (uint32_t addr, uint32_t data)
{
#ifdef DEBUG
    VPrint("csrWriteMem : addr = 0x%08x data = 0x%08x\n", addr, data); fflush(NULL);
#endif

    // Write over the AVS bus for this node
    VWrite(addr, data, NORMAL_UPDATE, node);
    
    // Model some access rate time
    VTick(AVS_ACCESS_LEN, node);
}

// --------------------------------------------------
// Read function to access memory directly (bypass sim)
// --------------------------------------------------
uint32_t directReadMem (uint32_t addr, uint32_t* data)
{
    uint32_t rdata;
    
    *data = ReadRamWord(addr, true, node);

#ifdef DEBUG
    VPrint("directReadMem : addr = 0x%08x data = 0x%08x\n", addr, *data); fflush(NULL);
#endif
    return 0;
}

// --------------------------------------------------
// Write function to access memory directly (bypass sim)
// --------------------------------------------------
void directWriteMem (uint32_t addr, uint32_t data)
{
#ifdef DEBUG
    VPrint("directWriteMem : addr = 0x%08x data = 0x%08x\n", addr, data); fflush(NULL);
#endif

    WriteRamWord(addr, data, true, node);
}

// --------------------------------------------------
// Simulation control functions
// --------------------------------------------------

void stopSim(bool error)
{
    csrWriteMem(TB_SIM_CTRL_REG, TB_SIM_CTRL_STOP_MASK   | (error ? TB_SIM_CTRL_ERROR_MASK : 0));
}

void finishSim(int error)
{
    csrWriteMem(TB_SIM_CTRL_REG, TB_SIM_CTRL_FINISH_MASK | (error ? TB_SIM_CTRL_ERROR_MASK : 0));
}

void usleepSim(unsigned time)
{
    VTick((time * 1000 * 1000)/sysClkPeriodPs, node);
}

void nsleepSim(unsigned time)
{
    uint64_t time64 = time;

    // Make ticks a minimum of 1, and do rounding to nearest clock period
    uint32_t ticks = ((time64 * 1000) < (sysClkPeriodPs) ? 1 : (time64 * 1000 + sysClkPeriodPs/2)/sysClkPeriodPs);

    VTick(ticks, node);
}

// ==================================================
// ENTRY POINT TO USER CODE FROM VPROC
// ==================================================

extern "C" void VUserMain0()
{
    int      error   = 0;
    int      testnum = MAINTESTNUM;
    uint32_t tmp1    = 0;
    uint32_t tmp2    = 0;
    
    CTestAuto* pTestBench = new CTestAuto((uint32_t*)(0));
    
    VPrint("\n*****************************\n");
    VPrint(  "* Virtual Processor (VProc) *\n");
    VPrint(  "*   Running on Riviera-PRO  *\n");
    VPrint(  "*     Copyright (c) 2023    *\n");
    VPrint(  "*****************************\n\n");
    
    VPrint("Entered VUserMain%d()\n\n", node);

    uint32_t clkFreqMHz     = pTestBench->pConfigClkFreq->GetConfigClkFreq();
    uint32_t sysClkPeriodPs = 1000000/clkFreqMHz;
    
    VPrint("Running at clock frequency %dMHz\n", clkFreqMHz);

    usleepSim(1);
    
    // Check we're alive by writing to memory over CSR bus
    csrWriteMem(MEM_BASE_ADDR + ALIVE_TEST_OFFSET, ALIVE_TEST_NUM);
    
    // Read back over CSR bus
    csrReadMem (MEM_BASE_ADDR + ALIVE_TEST_OFFSET, &tmp1);
    
    // Read directly from memory model (bypassing simulation)
    directReadMem (MEM_BASE_ADDR + ALIVE_TEST_OFFSET, &tmp2);
    
    if (tmp1 != ALIVE_TEST_NUM || tmp2 == ALIVE_TEST_NUM)
    {
        VPrint("\nVUserMain%d() failed start up memory access check\n\n", node);
        error = 1;
    }
    // If start up check passed, run user test code
    else
    {
        VPrint("Sanity check passed. Running test code...\n");
        
        // ##########################################
        // # Call test code here 
        // ##########################################
        uutTest *pTest = new uutTest();
        
        error |= pTest->runtest();
    }
 
    // Wait a bit
    usleepSim(1);

    // Tell the simulator to finish
    VPrint("\nVUserMain%d() finishing with status %d\n\n", node, error);
    finishSim(error);
    
    // Sleep for ever, ticking. Don't exit or loop forever internally
    // (e.g. while (1);) as simulation will hang.
    SLEEP_FOREVER;
}

