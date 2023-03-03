/*
 * CUutAuto.h
 *
 * >>> AUTO-GENERATED. DO NOT EDIT. <<<
 *
 */

#include <stdint.h>

#ifdef HDL_SIM
extern "C" uint32_t read_ext  (uint32_t addr, uint32_t* data);
extern "C" void     write_ext (uint32_t addr, uint32_t  data);
#endif

#ifndef CUUT_AUTO_H_
#define CUUT_AUTO_H_

#include "uut.h"

class CUutAuto
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
        inline uint32_t GetControl(){return CUutAuto::readReg(m_pvCsrBaseAddr + CSR_UUT_CONTROL/4);}
        inline uint32_t GetStartwr(){return (GetControl() & CSR_UUT_CONTROL_STARTWR_MASK) >> CSR_UUT_CONTROL_STARTWR;}
        inline void SetStartwr(uint32_t val){CUutAuto::writeReg(m_pvCsrBaseAddr + CSR_UUT_CONTROL/4, ((GetControl() & ~CSR_UUT_CONTROL_STARTWR_MASK) | ((val << CSR_UUT_CONTROL_STARTWR) & CSR_UUT_CONTROL_STARTWR_MASK)));}
        inline uint32_t GetStartrd(){return (GetControl() & CSR_UUT_CONTROL_STARTRD_MASK) >> CSR_UUT_CONTROL_STARTRD;}
        inline void SetStartrd(uint32_t val){CUutAuto::writeReg(m_pvCsrBaseAddr + CSR_UUT_CONTROL/4, ((GetControl() & ~CSR_UUT_CONTROL_STARTRD_MASK) | ((val << CSR_UUT_CONTROL_STARTRD) & CSR_UUT_CONTROL_STARTRD_MASK)));}
        inline uint32_t GetLength(){return (GetControl() & CSR_UUT_CONTROL_LENGTH_MASK) >> CSR_UUT_CONTROL_LENGTH;}
        inline void SetLength(uint32_t val){CUutAuto::writeReg(m_pvCsrBaseAddr + CSR_UUT_CONTROL/4, ((GetControl() & ~CSR_UUT_CONTROL_LENGTH_MASK) | ((val << CSR_UUT_CONTROL_LENGTH) & CSR_UUT_CONTROL_LENGTH_MASK)));}
        inline uint32_t GetClrerr(){return (GetControl() & CSR_UUT_CONTROL_CLRERR_MASK) >> CSR_UUT_CONTROL_CLRERR;}
        inline void SetClrerr(uint32_t val){CUutAuto::writeReg(m_pvCsrBaseAddr + CSR_UUT_CONTROL/4, ((GetControl() & ~CSR_UUT_CONTROL_CLRERR_MASK) | ((val << CSR_UUT_CONTROL_CLRERR) & CSR_UUT_CONTROL_CLRERR_MASK)));}
        inline void SetControl(uint32_t val){CUutAuto::writeReg(m_pvCsrBaseAddr + CSR_UUT_CONTROL/4, val);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CStatus
    {
    public:
        CStatus(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetStatus(){return CUutAuto::readReg(m_pvCsrBaseAddr + CSR_UUT_STATUS/4);}
        inline uint32_t GetBusy(){return (GetStatus() & CSR_UUT_STATUS_BUSY_MASK) >> CSR_UUT_STATUS_BUSY;}
        inline uint32_t GetError(){return (GetStatus() & CSR_UUT_STATUS_ERROR_MASK) >> CSR_UUT_STATUS_ERROR;}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    class CBaseaddr
    {
    public:
        CBaseaddr(uint32_t* blkBaseAddr) {m_pvCsrBaseAddr = blkBaseAddr;};
        inline uint32_t GetBaseaddr(){return CUutAuto::readReg(m_pvCsrBaseAddr + CSR_UUT_BASEADDR/4);}
        inline void SetBaseaddr(uint32_t val){CUutAuto::writeReg(m_pvCsrBaseAddr + CSR_UUT_BASEADDR/4, val);}
    private:
        volatile uint32_t* m_pvCsrBaseAddr;
    };

    
public:
    // Constructor. Create register objects relative to the passed in base address
    CUutAuto(uint32_t* csrBaseAddr = 0)
    {
        m_pvCsrBaseAddr = csrBaseAddr;

        pControl = new CControl(csrBaseAddr);
        pStatus = new CStatus(csrBaseAddr);
        pBaseaddr = new CBaseaddr(csrBaseAddr);
    };
    
public:
    
    // Pointers to the register objects
    CControl* pControl;
    CStatus* pStatus;
    CBaseaddr* pBaseaddr;
    
    // Pointers to the sub-block objects
    
    // Provide access to the base address used for this object
    inline volatile uint32_t* GetCsrBaseAddr() {return m_pvCsrBaseAddr;}
    
private:
    volatile uint32_t* m_pvCsrBaseAddr;
};

#endif /* CUUT_AUTO_H_ */
