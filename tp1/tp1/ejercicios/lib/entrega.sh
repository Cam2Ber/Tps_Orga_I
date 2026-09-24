#!/bin/sh
# Se invoca desde ejercicios/. Copia los originales; no necesita make deps. No ejecuta simulaciones.
set -eu
exercise_dir=$(pwd -P)
tp_dir=$(dirname "$exercise_dir")
output_dir="$tp_dir/entrega"
stage=$(mktemp -d "$tp_dir/.entrega.XXXXXX")
trap 'rm -rf "$stage"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
# Solo módulos desarrollados por los alumnos, desde sus ejercicios de origen.
for file in ej1/alu.sv ej3/datapath.sv ej4/registro_orden.sv ej5/fsm.sv ej6/top_module.sv; do
    mkdir -p "$stage/ejercicios/$(dirname "$file")"
    cp "$file" "$stage/ejercicios/$file"
done
# Actualizar solo el código generado; conservar las respuestas ya añadidas.
mkdir -p "$output_dir/respuestas"
rm -rf "$output_dir/ejercicios"
mv "$stage/ejercicios" "$output_dir/ejercicios"
if [ -d "$tp_dir/respuestas" ]; then
    cp -R "$tp_dir/respuestas/." "$output_dir/respuestas/"
fi
# Retirar archivos que generaba la versión anterior del empaquetador.
rm -f "$output_dir/Makefile" "$output_dir/README.md" "$output_dir/enunciado.pdf"
printf '\nEntrega generada en: %s\n' "$output_dir"
if [ ! -f "$output_dir/respuestas/respuestas.pdf" ]; then
    printf 'Falta respuestas/respuestas.pdf: incluir integrantes, cuentas, tabla y capturas.\n'
fi
printf 'Solo se copiaron módulos propios y respuestas. No se ejecutaron tests.\n'
