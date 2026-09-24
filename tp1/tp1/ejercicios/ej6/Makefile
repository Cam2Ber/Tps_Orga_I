TB = top_module_tb
SRCS = tp1_pkg.sv alu_if.sv bloques_alu.sv alu.sv reg_file.sv datapath.sv registro_orden.sv fsm.sv top_module.sv top_module_tb.sv
LIB = ../lib
include $(LIB)/sim.mk

deps:
	$(MAKE) -C "../ej3" deps
	cp "../ej3/tp1_pkg.sv" "tp1_pkg.sv"
	cp "../ej3/alu_if.sv" "alu_if.sv"
	cp "../ej3/bloques_alu.sv" "bloques_alu.sv"
	cp "../ej3/alu.sv" "alu.sv"
	cp "../ej3/reg_file.sv" "reg_file.sv"
	cp "../ej3/datapath.sv" "datapath.sv"
	$(MAKE) -C "../ej4" deps
	cp "../ej4/registro_orden.sv" "registro_orden.sv"
	$(MAKE) -C "../ej5" deps
	cp "../ej5/fsm.sv" "fsm.sv"

.PHONY: entrega
entrega:
	$(MAKE) -C .. entrega
