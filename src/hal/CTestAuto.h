/*
 * CTestAuto.h
 *
 * >>> AUTO-GENERATED. DO NOT EDIT. <<<
 *
 */

#include <stdint.h>

#ifdef HDL_SIM
extern "C" uint32_t read_ext  (uint32_t addr, uint32_t* data);
extern "C" void     write_ext (uint32_t addr, uint32_t  data);
#endif

#ifndef CTEST_AUTO_H_
#define CTEST_AUTO_H_

#include "test.h"
#include "CUutAuto.h"

class CTestAuto
{
    
private:
    // Single point read and write access methods to memory (allows overriding)
#ifdef HDL_SIM
    inline static uint32_t readReg (volatile uint32_t* p_addr)               {uint32_t addr, val; addr = (uint64_t)p_addr; read_ext(addr, &val); return val;};
    inline static void     writeReg(volatile uint32_t* p_addr, uint32_t val) {uint32_t addr = (uint64_t)p_addr; write_ext(addr, val);};
#else
    inline static uint32_t readReg (volatile uint32_t* p_addr)               {return *p_addr;};
    inline static void     writeReg(volatile uint32_t* p_addr, uint32_t val) {*p_addr = val;};
#endif

    // Internal register class definitions
    class CControl
    {
    public:
        CControl(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetControl(){return CTestAuto::readReg(m_pvCsrBaseAddr + CSR_TEST_CONTROL/4);}
        inline uint32_t GetError(){return (GetControl() & CSR_TEST_CONTROL_ERROR_MASK) >> CSR_TEST_CONTROL_ERROR;}
        inline void SetError(uint32_t val){CTestAuto::writeReg(m_pvCsrBaseAddr + CSR_TEST_CONTROL/4, ((GetControl() & ~CSR_TEST_CONTROL_ERROR_MASK) | ((val << CSR_TEST_CONTROL_ERROR) & CSR_TEST_CONTROL_ERROR_MASK)));}
        inline uint32_t GetDoStop(){return (GetControl() & CSR_TEST_CONTROL_DO_STOP_MASK) >> CSR_TEST_CONTROL_DO_STOP;}
        inline void SetDoStop(uint32_t val){CTestAuto::writeReg(m_pvCsrBaseAddr + CSR_TEST_CONTROL/4, ((GetControl() & ~CSR_TEST_CONTROL_DO_STOP_MASK) | ((val << CSR_TEST_CONTROL_DO_STOP) & CSR_TEST_CONTROL_DO_STOP_MASK)));}
        inline uint32_t GetDoFinish(){return (GetControl() & CSR_TEST_CONTROL_DO_FINISH_MASK) >> CSR_TEST_CONTROL_DO_FINISH;}
        inline void SetDoFinish(uint32_t val){CTestAuto::writeReg(m_pvCsrBaseAddr + CSR_TEST_CONTROL/4, ((GetControl() & ~CSR_TEST_CONTROL_DO_FINISH_MASK) | ((val << CSR_TEST_CONTROL_DO_FINISH) & CSR_TEST_CONTROL_DO_FINISH_MASK)));}
        inline uint32_t GetPartialTest(){return (GetControl() & CSR_TEST_CONTROL_PARTIAL_TEST_MASK) >> CSR_TEST_CONTROL_PARTIAL_TEST;}
        inline void SetPartialTest(uint32_t val){CTestAuto::writeReg(m_pvCsrBaseAddr + CSR_TEST_CONTROL/4, ((GetControl() & ~CSR_TEST_CONTROL_PARTIAL_TEST_MASK) | ((val << CSR_TEST_CONTROL_PARTIAL_TEST) & CSR_TEST_CONTROL_PARTIAL_TEST_MASK)));}
        inline void SetControl(uint32_t val){CTestAuto::writeReg(m_pvCsrBaseAddr + CSR_TEST_CONTROL/4, val);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CTimeCount
    {
    public:
        CTimeCount(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetTimeCount(){return CTestAuto::readReg(m_pvCsrBaseAddr + CSR_TEST_TIME_COUNT/4);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CTimeout
    {
    public:
        CTimeout(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetTimeout(){return CTestAuto::readReg(m_pvCsrBaseAddr + CSR_TEST_TIMEOUT/4);}
        inline void SetTimeout(uint32_t val){CTestAuto::writeReg(m_pvCsrBaseAddr + CSR_TEST_TIMEOUT/4, val);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CConfigClkFreq
    {
    public:
        CConfigClkFreq(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetConfigClkFreq(){return CTestAuto::readReg(m_pvCsrBaseAddr + CSR_TEST_CONFIG_CLK_FREQ/4);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    
public:
    // Constructor. Create register objects relative to the passed in base address
    CTestAuto(uint32_t* csrBaseAddr = 0)
    {
        m_pvCsrBaseAddr = csrBaseAddr;

        pControl = new CControl(csrBaseAddr + CSR_TEST_LOCAL/4);
        pTimeCount = new CTimeCount(csrBaseAddr + CSR_TEST_LOCAL/4);
        pTimeout = new CTimeout(csrBaseAddr + CSR_TEST_LOCAL/4);
        pConfigClkFreq = new CConfigClkFreq(csrBaseAddr + CSR_TEST_LOCAL/4);
        pUut = new CUutAuto(csrBaseAddr + CSR_TEST_UUT/4);
    };
    
public:
    
    // Pointers to the register objects
    CControl* pControl;
    CTimeCount* pTimeCount;
    CTimeout* pTimeout;
    CConfigClkFreq* pConfigClkFreq;
    
    // Pointers to the sub-block objects
    CUutAuto* pUut;
    
    // Provide access to the base address used for this object
    inline volatile uint32_t* GetCsrBaseAddr() {return m_pvCsrBaseAddr;}
    
private:
    volatile uint32_t* m_pvCsrBaseAddr;
};

#endif /* CTEST_AUTO_H_ */
