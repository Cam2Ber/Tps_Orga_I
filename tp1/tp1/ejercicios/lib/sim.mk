# SRCS y TB se definen en el Makefile de cada ejercicio.
.DEFAULT_GOAL := sim
VERILATOR ?= verilator
SURFER ?= surfer
export VERILATOR SURFER
.PHONY: sim wave clean deps
sim wave: deps
	@sh "$(LIB)/sim.sh" "$@" "$(TB)" $(SRCS)
clean:
	rm -rf obj_dir
