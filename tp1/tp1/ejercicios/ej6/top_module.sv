import tp1_pkg::*;

module top_module (
    input logic clk, rst, start,
    input logic [4:0] rs1, rs2, rd,
    input logic [2:0] opcode,
    output logic ready, done,
    output alu_flags_t alu_flags
);
    logic capture_en, rf_we;
    logic [4:0] rs1_q, rs2_q, rd_q;
    logic [2:0] op_q;
    logic [31:0] result;
    // COMPLETAR: conexiones por nombre de las tres instancias.
    fsm u_fsm (
        .clk(clk), .rst(rst), .start(start),
        .ready(ready), .done(done), .capture_en(capture_en), .rf_we(rf_we)
    );
    registro_orden u_orden (
        .clk(clk), .rst(rst), .capture_en(capture_en),
        .rs1(rs1), .rs2(rs2), .rd(rd), .opcode(opcode),
        .rs1_q(rs1_q), .rs2_q(rs2_q), .rd_q(rd_q), .op_q(op_q)
    );
    datapath u_datapath (
        .clk(clk), .rst(rst), .rs1(rs1_q), .rs2(rs2_q), .rd(rd_q),
        .opcode(op_q), .rf_we(rf_we), .result(result), .flags(alu_flags)
    );
endmodule

/*
En el primer flanco se recibe la operacion y la posicion de los registros a aceder, junto con los permisos de escriura, sesteando la salida del registro hacia la operacion. En el segundo flanco se mantiene la lectura anterior para poder permitir que otros elementos la utilizen. En ambos casos para esta ejecucion las registries seleccionadas son R1 y R2. que serian 10 y 20, y en ese clock que se menciono donde se mantienen los valores para la lectura es donde se actuliza el output del ALU correctamente mostrando la operacion elegigida mediante un multiplexor basado en el opcode de las flags. En este caso el Opcode es 0 que corresponde a la suma, por lo tanto el output es la suma de 10 y 20, que seria 30. Posteriormente en el próximo clock como esta el write enable activado el registro A se ve sobrescrito, y luego de otro clock se actualiza el valor que esta siendo enviado por el registro hacia los operadores de la ALU. Repitiendo el "ciclo" de operaciones en la forma de una maquina de MOORE
*/
