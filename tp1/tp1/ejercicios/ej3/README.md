# Ejercicio 3 — Camino de datos

Conectar las salidas del banco a la ALU, el resultado a la escritura y el mux del índice A.

- **Archivo a completar:** `datapath.sv`.
- **Dependencias:** ALU, sus cuatro componentes, interfaz y package de ej1; banco de ej2.
- **PASS verifica:** Resultado y flags, escritura en destino, conservación de orígenes y reutilización del resultado.

```sh
make sim
make wave
```

`make sim` actualiza las copias importadas antes de compilar. Editar las dependencias
en su ejercicio de origen. No modificar los testbenches. Traza: `obj_dir/sim.vcd`.
