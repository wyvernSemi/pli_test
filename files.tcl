# #########################################
# Add project specific files here
# #########################################

uut_csr_regs_auto.v
uut.v

# #########################################

# Testbench files

# Test bench registers and address decode
./test_csr_decode_auto.v
./test_csr_regs_auto.v

# Virtual processor and Avalon memory mapped bus master wrapper
./avmvproc.v
../vproc/f_VProc.v

# Memory model
../mem_model/mem_model_q.v
../mem_model/mem_model.v

# Test bench control block
./tb_ctrl.v

# Test bench top level
./tb.v