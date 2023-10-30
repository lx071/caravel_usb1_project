
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
_RTL_TARGETS_=	$(DUT_SRC_DIR)/aes128/core/aes_sbox.sv			    \
		    $(DUT_SRC_DIR)/aes128/core/aes_rcon.sv			    \
		    $(DUT_SRC_DIR)/aes128/core/aes_key_expand_128.sv	\
		    $(DUT_SRC_DIR)/aes128/core/aes_cipher_top.sv		\
		    $(DUT_SRC_DIR)/aes128/core/aes_inv_sbox.sv			\
		    $(DUT_SRC_DIR)/aes128/core/aes_inv_cipher_top.sv    \
		    $(DUT_SRC_DIR)/aes128/top/aes_top.sv                \
		    $(DUT_SRC_DIR)/aes128/top/aes_reg.sv                \
		    $(DUT_SRC_DIR)/lib/registers.v                      \
		    $(DUT_SRC_DIR)/lib/reset_sync.sv                    \
		    $(DUT_SRC_DIR)/lib/clk_skew_adjust.gv               \
		    $(DUT_SRC_DIR)/lib/ctech_cells.sv

GL_SRC_DIR=../../gl
_GL_TARGETS_= $(GL_SRC_DIR)/aes_top.v			\
              $(PDK_ROOT)/sky130B/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
              $(PDK_ROOT)/sky130B/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
              $(PDK_ROOT)/sky130B/libs.ref/sky130_fd_sc_hvl/verilog/primitives.v


### To Enable IVERILOG FST DUMP
export IVERILOG_DUMPER = fst

# Targets
.PHONY: clean rtl gate help

default: clean rtl

rtl: clean  
ifeq ($(SIM),RTL)
   ifeq ($(DUMP),OFF)
	iverilog -g2012  -D SPEEDSIM  -DFUNCTIONAL -DSIM -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/sky130B    $(_TB_) $(_RTL_TARGETS_)  -o tb_top.vvp
    else  
	iverilog -g2012  -D SPEEDSIM  -DFUNCTIONAL -DSIM -DWFDUMP -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/sky130B    $(_TB_) $(_RTL_TARGETS_)  -o tb_top.vvp
   endif
else  
   ifeq ($(DUMP),OFF)
	iverilog -g2012  -D GL -D SPEEDSIM  -DFUNCTIONAL -DSIM -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/sky130B  $(_TB_) $(_GL_TARGETS_)  -o tb_top.vvp
    else  
	iverilog -g2012  -D GL -D SPEEDSIM  -DFUNCTIONAL -DSIM -DWFDUMP -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/sky130B    $(_TB_) $(_GL_TARGETS_)  -o tb_top.vvp
   endif
endif
	vvp tb_top.vvp

gate: clean  
	iverilog -g2012  -D GL -D SPEEDSIM  -DFUNCTIONAL -DSIM -DWFDUMP -I ./$(DUT_SRC_DIR)/ -I ./$(TB_SRC_DIR)/ -I $(PDK_ROOT)/sky130A  $(_TB_) $(_GL_TARGETS_) -o tb_top.vvp
	vvp tb_top.vvp

help:
	@echo "To run RTL  simulation: make rtl"
	@echo "To run Gate simulation: make gate"



clean:
	$(RM) -R *.vvp
	$(RM) -R *.vcd
	$(RM) -R *.fst
