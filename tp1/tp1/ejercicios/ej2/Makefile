TB = reg_file_tb
SRCS = tp1_pkg.sv reg_file.sv reg_file_tb.sv
LIB = ../lib
include $(LIB)/sim.mk

deps:
	$(MAKE) -C "../ej1" deps
	cp "../ej1/tp1_pkg.sv" "tp1_pkg.sv"

.PHONY: entrega
entrega:
	$(MAKE) -C .. entrega
