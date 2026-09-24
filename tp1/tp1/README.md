# TP1 — ALU, banco de registros y unidad de control

Enunciado: [PDF](../enunciado/enunciado.pdf) · [fuente Typst](../enunciado/enunciado.typ).

| Ejercicio | Archivo a completar | Módulo superior | Prueba |
| --- | --- | --- | --- |
| 1 | `ejercicios/ej1/alu.sv` | `alu` | Operaciones y flags |
| 2 | Ninguno; tabla de lecturas y escrituras | `reg_file` | Banco síncrono provisto |
| 3 | `ejercicios/ej3/datapath.sv` | `datapath` | ALU + banco, control externo |
| 4 | `ejercicios/ej4/registro_orden.sv` | `registro_orden` | Captura y retención de la orden |
| 5 | `ejercicios/ej5/fsm.sv` | `fsm` | Secuencia y señales de control |
| 6 | `ejercicios/ej6/top_module.sv` | `top_module` | Unidad completa |

## Uso

Abrir `tp` con el Dev Container provisto, como en el paquete original.

Desde la carpeta de cada ejercicio:

```sh
make sim     # copia dependencias, compila y ejecuta las pruebas
make wave    # vuelve a simular; abre la traza si todas las pruebas pasan
make deps    # actualiza únicamente los archivos importados
make clean   # elimina obj_dir; conserva todos los fuentes
```

Las plantillas compilan, pero sus pruebas fallan hasta completarlas. El ejercicio 2
está provisto y pasa sin cambios. Ante un fallo de simulación, la traza parcial está
en `obj_dir/sim.vcd`; se puede abrir manualmente. Los logs quedan en `obj_dir/`.
Si no está instalado Surfer, `make wave` indica la ruta de la traza.

Editar cada módulo **solo en su ejercicio de origen**. `make sim` y `make deps`
sobrescriben las copias importadas; nunca sobrescriben el módulo propio del ejercicio.
En ej6 se actualizan también las dependencias de ej3: no hace falta ejecutar los
Makefiles intermedios después de corregir la ALU.

```text
ej1/alu.sv + ej2/reg_file.sv → ej3/datapath.sv
                                          ↘
ej4/registro_orden.sv ───────────────────→ ej6/top_module.sv
ej5/fsm.sv ──────────────────────────────↗
```

Ej4 y ej5 no necesitan copiar módulos anteriores para sus pruebas aisladas.
`tp1_pkg.sv`, `alu_if.sv` y `bloques_alu.sv` tienen su origen en ej1.
Este último contiene sumador, restador, comparador de igualdad y detector de signo
de 32 bits, provistos completos. Los alumnos conectan los bloques en `alu.sv`;
no necesitan editar los Makefiles. Los componentes y testbenches están provistos.
Las fuentes y dependencias se declaran en cada Makefile; no se usa `sim.json`.

Desde `ejercicios/`, `make sim` ejecuta los seis ejercicios, continúa tras los fallos
y termina con error si alguno falla. Desde esta carpeta, `make enunciado` recompila
el PDF. Requisitos: shell POSIX, Verilator 5, Make y compilador C++; Typst para el PDF.
La simulación no requiere Python.
`VERILATOR` y `SURFER` permiten seleccionar ejecutables.

El build de Verilator se realiza en un temporal sin espacios y copia la traza al
proyecto. Las rutas del proyecto y `TMPDIR` pueden contener espacios.

Para HDL Studio: ejecutar `make deps`, agregar los `.sv` de la carpeta salvo el
`*_tb.sv` y seleccionar el módulo superior de la tabla. En ej1 incluir la interfaz
y el package provistos.

## Distribución del material a estudiantes

Distribuir `tp/` y su carpeta hermana `enunciado/`, sin `obj_dir/`.
Las soluciones y el verificador docente quedan fuera del paquete, en
`../verificacion/`.

## Armar la entrega

Desde `tp/`, `ejercicios/` o cualquier `ejN/`:

```sh
make entrega
```

Genera `tp/entrega/` con únicamente los módulos que completan los alumnos:
`ej1/alu.sv`, `ej3/datapath.sv`, `ej4/registro_orden.sv`, `ej5/fsm.sv` y
`ej6/top_module.sv`, bajo `ejercicios/`. Se copian desde sus ejercicios de origen.
No incluye componentes provistos, testbenches, Makefiles, enunciado ni compilados.

Crear `tp/respuestas/respuestas.pdf` con integrantes, cuentas del ej1, tabla y
respuesta del ej2, explicación del ej3 y captura y respuestas del ej6. El comando
copia `tp/respuestas/` a `tp/entrega/respuestas/` y avisa si falta el PDF.
Las capturas deben estar incluidas en ese PDF.

Al repetir el comando se reemplazan los módulos empaquetados y se conservan las
respuestas ya agregadas; los archivos de `tp/respuestas/` actualizan los del mismo
nombre. Entregar la carpeta `entrega/` completa. `make entrega` no ejecuta pruebas
ni comprueba que las respuestas estén completas; ejecutar `make sim` en el TP.
