.DEFAULT_GOAL := sim
.PHONY: sim deps clean
sim deps clean:
	@status=0; for ej in ej1 ej2 ej3 ej4 ej5 ej6; do \
		$(MAKE) -C "$$ej" "$@" || status=1; \
	done; exit $$status

.PHONY: entrega
entrega:
	@sh lib/entrega.sh
