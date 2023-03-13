###################################################################
# Makefile for PLI test bench
#
# Copyright (c) 2023 Simon Southwell
#
###################################################################

# User files to build, passed in to vproc makefile build
USERCODE           = VUserMain0.cpp uutTest.cpp

VPROC_PLI          = VProc.so

MAKE_EXE           = make
VSIMEXE            = vsim
VLOGFLAGS          = -sv2k5 -msg 0
VSIMFLAGS          = +access +r -pli ${VPROC_PLI}

# Location of VProc directory
VPROCDIR           = ${CURDIR}/../vproc

#Location of meory model directory
MEMMODELDIR        = ${CURDIR}/../mem_model/src
MEM_C              = mem.c mem_model.c

# If no external code directory (e.g. a HAL) set this to local source directory, else set to code directory
EXTINCLDIR         = ${CURDIR}/src

USRFLAGS           = -I${MEMMODELDIR} -DINCL_VLOG_MEM_MODEL -DHDL_SIM -DVPROC_PLI_VPI

SIMLOGFILE         = sim.log

#------------------------------------------------------
# BUILD RULES
#------------------------------------------------------

# Build is dependent on generating the auto-gen file and
# processing makefile in vproc
all: verilog

# Call the vproc make file for it to determine if anything
# needs building.
.PHONY : vproc
vproc:
	@${MAKE_EXE} --no-print-directory                      \
                 -C ${VPROCDIR}                            \
                 MEMMODELDIR=${MEMMODELDIR}                \
                 MEM_C="${MEM_C}"                          \
                 TESTDIR=${CURDIR}                         \
                 USRCDIR=${CURDIR}/src                     \
                 USER_C="${USERCODE}"                      \
                 USRFLAGS="${USRFLAGS}"                    \
                 EXTINCLDIR="${EXTINCLDIR}"

verilog: vproc
	@if [ ! -d "./work" ]; then                            \
	  vlib work;                                           \
	fi
	@vlog ${VLOGFLAGS} -f files.tcl

#------------------------------------------------------
# EXECUTION RULES
#------------------------------------------------------

run: all
	@vsim -c ${VSIMFLAGS} -l ${SIMLOGFILE} -do run.do tb

rungui: all
	@if [ -e wave.do ]; then                               \
	  vsim -gui -l ${SIMLOGFILE} -do wave.do ${VSIMFLAGS}; \
	else                                                   \
	  vsim -gui -l ${SIMLOGFILE} ${VSIMFLAGS};             \
	fi

autobuild:
	@${AUTOSCRIPT}

gui: rungui

sim: run

#------------------------------------------------------
# CLEANING RULES
#------------------------------------------------------

clean:
	@${MAKE_EXE} --no-print-directory -C ${VPROCDIR} USER_C="${USERCODE}" TESTDIR="${CURDIR}" clean
	@rm -rf work
	@rm -rf obj
	@rm -rf dataset.asdb
	@rm -rf library.cfg
	@rm -rf sim.log

