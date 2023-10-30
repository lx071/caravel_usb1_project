
# // //////////////////////////////////////////////////////////////////////////
#------------------------------------------------------------------------------
# Makefile for Synthesis
#------------------------------------------------------------------------------

# Paths
export ROOT_DIR := $(shell pwd)

## Simulation mode: RTL/GL
SIM?=RTL
DUMP?=OFF

##########################################################################
#
# Test Bench Sources
#
##########################################################################
TB_SRC_DIR=./
_TB_=		$(TB_SRC_DIR)/tb_top.v	

##########################################################################
#
# DUT Sources
#
##########################################################################
DUT_SRC_DIR=../../rtl
_RTL_TARGETS_=	$(DUT_SRC_DIR)/core/rtc_core.sv \
                $(DUT_SRC_DIR)/core/rtc_reg.sv  \
                $(DUT_SRC_DIR)/core/rtc_top.sv   \
                $(DUT_SRC_DIR)/lib/async_reg_bus.sv \
                $(DUT_SRC_DIR)/lib/reset_sync.sv	\
                $(DUT_SRC_DIR)/lib/ctech_cells.sv

GL_SRC_DIR=../../gl
_GL_TARGETS_= $(GL_SRC_DIR)/rtc_core.v			\
              $(PDK_ROOT)/sky130B/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
              $(PDK_ROOT)/sky130B/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
              $(PDK_ROOT)/sky130B/libs.ref/sky130_fd_sc_hvl/verilog/primitives.v


### To Enable IVERILOG FST DUMP
export IVERILOG_DUMPER = fst

# Targets
.PHONY: clean rtl gate help

default: clean rtl

rtl: clean  
	iverilog-vpi pli_rtc.c
ifeq ($(SIM),RTL)
   ifeq ($(DUMP),OFF)
	iverilog -g2012  -D SPEEDSIM  -DFUNCTIONAL -DSIM -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/$(PDK)    $(_TB_) $(_RTL_TARGETS_)  -o tb_top.vvp
    else  
	iverilog -g2012  -D SPEEDSIM  -DFUNCTIONAL -DSIM -DWFDUMP -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/$(PDK)    $(_TB_) $(_RTL_TARGETS_)  -o tb_top.vvp
   endif
else  
   ifeq ($(DUMP),OFF)
	iverilog -g2012  -D GL -D SPEEDSIM  -DFUNCTIONAL -DSIM -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/$(PDK)  $(_TB_) $(_GL_TARGETS_)  -o tb_top.vvp
    else  
	iverilog -g2012  -D GL -D SPEEDSIM  -DFUNCTIONAL -DSIM -DWFDUMP -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/$(PDK)    $(_TB_) $(_GL_TARGETS_)  -o tb_top.vvp
   endif
endif
	vvp -M. -m pli_rtc tb_top.vvp

gate: clean  
	iverilog -g2012  -D GL -D SPEEDSIM  -DFUNCTIONAL -DSIM -DWFDUMP -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/$(PDK)  $(_TB_) $(_GL_TARGETS_) -o tb_top.vvp
	vvp tb_top.vvp

help:
	@echo "To run RTL  simulation: make rtl"
	@echo "To run Gate simulation: make gate"



clean:
	$(RM) -R *.vvp
	$(RM) -R *.vcd
	$(RM) -R *.fst
	$(RM) -R *.o
	$(RM) -R *.vpi
