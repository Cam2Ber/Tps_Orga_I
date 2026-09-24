#!/bin/sh
# Compilar fuera del proyecto evita que el Makefile generado por Verilator
# interprete mal las rutas con espacios. No requiere Python ni un lector JSON.
set -eu
action=$1
tb=$2
shift 2
project_dir=$(pwd -P)
output_dir="$project_dir/obj_dir"
mkdir -p "$output_dir"
rm -f "$output_dir/sim.vcd"
build_dir=$(mktemp -d /tmp/tp1-sim.XXXXXX)
trap 'rm -rf "$build_dir"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
for source in "$@"; do
    cp "$source" "$build_dir/"
done
printf '[sim] %s: compilando\n' "$tb"
cd "$build_dir"
# Compilar cada C++ por separado evita verilator_includer (usa Python).
if "${VERILATOR:-verilator}" --binary --timing --trace --top-module "$tb" \
    -j 2 -MAKEFLAGS VM_PARALLEL_BUILDS=1 -Wall -Wno-fatal "$@" > "$output_dir/build.log" 2>&1; then
    sed -n '/^%Warning/p' "$output_dir/build.log" >&2
else
    code=$?
    cat "$output_dir/build.log" >&2
    exit "$code"
fi
code=0
"./obj_dir/V$tb" > "$output_dir/sim.log" 2>&1 || code=$?
cat "$output_dir/sim.log"
if [ -f sim.vcd ]; then cp sim.vcd "$output_dir/sim.vcd"; fi
if [ "$code" -ne 0 ]; then exit "$code"; fi
if [ "$action" = wave ]; then
    if command -v "${SURFER:-surfer}" >/dev/null 2>&1; then
        "${SURFER:-surfer}" "$output_dir/sim.vcd" >/dev/null 2>&1 &
    else
        printf 'Abrir en el visor de ondas: %s/sim.vcd\n' "$output_dir"
    fi
fi
