# Ejercicio 4 — Registro de la orden

Guardar los cuatro campos de la orden cuando capture_en=1; conservarlos en otro caso.

- **Archivo a completar:** `registro_orden.sv`.
- **Dependencias:** Ninguna. Se prueba por separado y se incorpora en ej6.
- **PASS verifica:** Captura en flanco, retención, recaptura y reset asíncrono.

```sh
make sim
make wave
```

`make sim` actualiza las copias importadas antes de compilar. Editar las dependencias
en su ejercicio de origen. No modificar los testbenches. Traza: `obj_dir/sim.vcd`.
