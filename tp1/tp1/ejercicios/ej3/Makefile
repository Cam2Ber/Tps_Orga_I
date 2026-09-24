TB = datapath_tb
SRCS = tp1_pkg.sv alu_if.sv bloques_alu.sv alu.sv reg_file.sv datapath.sv datapath_tb.sv
LIB = ../lib
include $(LIB)/sim.mk

deps:
	$(MAKE) -C "../ej1" deps
	cp "../ej1/tp1_pkg.sv" "tp1_pkg.sv"
	cp "../ej1/alu_if.sv" "alu_if.sv"
	cp "../ej1/bloques_alu.sv" "bloques_alu.sv"
	cp "../ej1/alu.sv" "alu.sv"
	$(MAKE) -C "../ej2" deps
	cp "../ej2/reg_file.sv" "reg_file.sv"

.PHONY: entrega
entrega:
	$(MAKE) -C .. entrega
