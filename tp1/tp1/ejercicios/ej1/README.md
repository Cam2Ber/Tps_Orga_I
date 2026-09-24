# Ejercicio 1 — ALU de 32 bits

Completar `alu.sv`: conectar los cuatro componentes provistos en `bloques_alu.sv`
y seleccionar resultado y flags para ADD, SUB, AND y OR.

- `sumador_flags`: suma, carry y overflow.
- `restador_flags`: resta, préstamo (C) y overflow.
- `comparador`: igualdad entre dos datos de 32 bits; conectar resultado y cero para Z.
- `negativo`: bit más significativo del dato (bit 31) para N.

El comparador y el detector de negativo se aplican al resultado seleccionado de
cualquiera de las cuatro operaciones. AND/OR usan `&`/`|` y C=V=0. Para opcode
inválido, resultado=0 y Z/N/C/V=0100.

Editar solo `alu.sv`. Los componentes, `tp1_pkg.sv`, `alu_if.sv`, el testbench y
los Makefiles están provistos. No es necesario agregar archivos ni editar la
configuración de simulación. No se requiere Python.

```sh
make sim
make wave
```

PASS verifica los componentes, resultados, signo, cero, carry, overflow y opcodes
inválidos. La traza está en `obj_dir/sim.vcd`.
