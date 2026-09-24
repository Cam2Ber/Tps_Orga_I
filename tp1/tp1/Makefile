TYPST ?= typst
.DEFAULT_GOAL := sim
.PHONY: sim deps clean enunciado entrega
sim deps clean entrega:
	$(MAKE) -C ejercicios $@
enunciado:
	"$(TYPST)" compile ../enunciado/enunciado.typ ../enunciado/enunciado.pdf
	cp ../enunciado/enunciado.pdf ../enunciado/enunciado_32bits.pdf
