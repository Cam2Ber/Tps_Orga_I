// Cuatro componentes provistos. Datos de 32 bits por defecto.
// Se agrupan en un archivo para evitar dependencias de sumadores de un bit.
/* verilator lint_off DECLFILENAME */
module sumador_flags #(parameter int DATA_WIDTH = 32) (
    input logic [DATA_WIDTH-1:0] a, b,
    output logic [DATA_WIDTH-1:0] sum,
    output logic carry, overflow
);
    assign {carry, sum} = {1'b0, a} + {1'b0, b};
    assign overflow = (a[DATA_WIDTH-1] == b[DATA_WIDTH-1]) &&
                      (sum[DATA_WIDTH-1] != a[DATA_WIDTH-1]);
endmodule

module restador_flags #(parameter int DATA_WIDTH = 32) (
    input logic [DATA_WIDTH-1:0] a, b,
    output logic [DATA_WIDTH-1:0] resta,
    output logic carry, overflow
);
    assign resta = a - b;
    // En este TP, C de SUB indica préstamo unsigned.
    assign carry = (a < b);
    assign overflow = (a[DATA_WIDTH-1] != b[DATA_WIDTH-1]) &&
                      (resta[DATA_WIDTH-1] != a[DATA_WIDTH-1]);
endmodule

module comparador #(parameter int DATA_WIDTH = 32) (
    input logic [DATA_WIDTH-1:0] a, b,
    output logic iguales
);
    assign iguales = (a == b);
endmodule

module negativo #(parameter int DATA_WIDTH = 32) (
    input logic [DATA_WIDTH-1:0] dato,
    output logic negativo
);
    // Bit más significativo: bit 31 con DATA_WIDTH=32, no bit 0.
    assign negativo = dato[DATA_WIDTH-1];
endmodule
