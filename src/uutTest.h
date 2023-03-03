/**************************************************************/
/* uutTest.h                                 Date: 2023/03/03 */
/*                                                            */
/* Copyright (c) 2023 Simon Southwell. All rights reserved.   */
/*                                                            */
/**************************************************************/

#ifndef __UUTTEST_H_
#define __UUTTEST_H_

//extern int uutTest();

class uutTest
{
public:
    const uint32_t wr_offset = 0x10000000;
    const uint32_t rd_offset = 0x20000000;
    const uint32_t bufsize   = 4096;
    const uint32_t badchar   = 0x2e;
    const uint32_t filtchar  = 0x20;
    
          uutTest() {};
      int runtest(void);
private:
      int wait_for_uut(const CUutAuto*  pUut);
};

#endif