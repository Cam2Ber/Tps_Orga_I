# Ejercicio 6 — Unidad completa

Completar las conexiones de las tres instancias provistas.

- **Archivo a completar:** `top_module.sv`.
- **Dependencias:** Datapath, ALU y sus cuatro componentes de ej3; registro de orden de ej4; FSM de ej5.
- **PASS verifica:** Escritura efectiva, flags, operaciones dependientes, cambios de entradas, start ocupado y R0.

```sh
make sim
make wave
```

`make sim` actualiza las copias importadas antes de compilar. Editar las dependencias
en su ejercicio de origen. No modificar los testbenches. Traza: `obj_dir/sim.vcd`.
