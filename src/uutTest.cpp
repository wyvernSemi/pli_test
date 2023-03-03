/**************************************************************/
/* uutTest.cpp                               Date: 2023/03/03 */
/*                                                            */
/* Copyright (c) 2023 Simon Southwell. All rights reserved.   */
/*                                                            */
/**************************************************************/
#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include "tb.h"
#include "hal/CTestAuto.h"
#include "uutTest.h"

// Access to memory model's direct API (C linkage)
extern "C" {
#include "VUser.h"
#include "mem_model.h"
}

// --------------------------------------------------
// Wait for UUT to
// --------------------------------------------------
int uutTest::wait_for_uut(const CUutAuto*  pUut)
{
    int error = 0;

    int32_t  timeoutNs   = 150000;  // 500us
    uint32_t sleepWaitNs = 500;     // 500ns

    // Wait until not busy or error or timed out
    while(timeoutNs > 0)
    {
        // Get full value of status register
        uint32_t status = pUut->pStatus->GetStatus();

        // If not busy or an error is flagged...
        if (!(status & CSR_UUT_STATUS_BUSY_MASK) || (status & CSR_UUT_STATUS_ERROR_MASK))
        {
            // Extract error status
            if (error = (status & CSR_UUT_STATUS_ERROR_MASK))
            {
                VPrint("***ERROR: seen error status in UUT\n");
            }
            break;
        }

        // Advance simulation a set period to reduce number of polls
        nsleepSim(sleepWaitNs);
        
        // Subtract sleep time from timeout
        timeoutNs -= sleepWaitNs;
    }

    // If timeout fired, flag an error
    if (timeoutNs <= 0)
    {
        error |= 1;
        VPrint("***ERROR: test code timed out waiting for UUT\n");
    }

    // return error status
    return error;
}

// --------------------------------------------------
// UUT test code
// --------------------------------------------------

int uutTest::runtest(void)
{    
    int c;
    int      error = 0;
    int      wdx   = 0; // Index for words
    int      bdx   = 0; // index for bytes
    uint32_t word  = 0;
    uint8_t  expbuf [bufsize];

    // Create a test bench HAL object
    CTestAuto* pTestBench = new CTestAuto((uint32_t*)(0));

    // Extract the UUT HAL
    CUutAuto*  pUut       = pTestBench->pUut;

    // Open test file
    FILE* fp = fopen("testfiles/test.txt", "r");

    // Load  file data directly into memory
    while ((c = fgetc(fp)) != EOF)
    {
        // Print out file character to console
        VPrint("%c", c & 0xff);
        
        // Generate the expected values, filtering the bad characters
        expbuf[bdx] = (c == badchar) ? filtchar : c;
        
        // Construct a 32-bit word from the incoming bytes
        word |= (c & 0xff) << (8*(bdx%4));
        
        // When word completed, write it directly to memory
        if ((bdx%4) == 3)
        {
            directWriteMem (rd_offset + bdx, word);
            word = 0;
        }
        bdx++;
    }

    // Caluclate file lengths (bytes then words rounded up)
    int filelen_bytes = bdx;
    int filelen_words = bdx/4 + ((bdx%4) ? 1 : 0);

    // Instigate a read transfer from UUT
    pUut->pControl->SetLength(filelen_words);
    pUut->pBaseaddr->SetBaseaddr(rd_offset);
    pUut->pControl->SetStartrd(1);

    // Wait for the UUT to finish
    error |= wait_for_uut(pUut);

    // If no errors, send processed data back to memory at new location
    if (!error)
    {
        // Intigate a write DMA from UUT to different location
        // (the length won't have changed)
        pUut->pBaseaddr->SetBaseaddr(wr_offset);
        pUut->pControl->SetStartwr(1);

        // Wait for UUT
        error |= wait_for_uut(pUut);

        if (!error)
        {
            // Read data from memory and print to console
            for (wdx = 0; wdx < filelen_words; wdx++)
            {
                // Do direct access from memory
                directReadMem(wr_offset + wdx*4, &word);

                // Extract the bytes form the word
                for (bdx = 0; bdx < 4; bdx++)
                {
                    // Caluculate the byte offset
                    uint32_t baddr = wdx*4+bdx;
                    
                    // Get the byte
                    uint32_t byte  = (word >> (bdx*8)) & 0xff;
                    
                    // Compare with expected and terminate if failed
                    if (expbuf[baddr] != byte)
                    {
                        VPrint("***ERROR: Mismatch on received data starting at addr 0x%08x. Got 0x%02x, Exp 0x%02x\n", baddr, byte, expbuf[baddr]);
                        error |= 1;
                        break;
                    }
                    
                    // Print out byte value to console
                    VPrint("%c", (word >> (bdx*8)) & 0xff);
                }
                if (error)
                {
                    break;
                }
            }
        }
    }

    // Return error status
    return error;
}