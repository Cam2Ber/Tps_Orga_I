import tp1_pkg::*;

// Los índices y el opcode deben permanecer estables durante la operación.
module datapath (
    input logic clk, rst,
    input logic [4:0] rs1, rs2, rd,
    input logic [2:0] opcode,
    input logic rf_we,
    output logic [31:0] result,
    output alu_flags_t flags
);
    logic [4:0] regA_idx;
    logic [31:0] rf_rs1_data, rf_rs2_data;
    alu_if alu_io ();
    alu u_alu (.alu_io(alu_io));

    assign alu_io.operand_a = rf_rs1_data;
    assign alu_io.operand_b = rf_rs2_data;
    assign flags = alu_io.flags;
    assign regA_idx = rf_we == 0 ? rs1 : rd;
    assign result = alu_io.result;

    reg_file u_reg_file (
        .clk(clk), .rst(rst),
        .regA_idx(regA_idx), .regA_din(result),
        .regA_dout(rf_rs1_data), .regA_we(rf_we),
        .regB_idx(rs2), .regB_din(32'b0),
        .regB_dout(rf_rs2_data), .regB_we(1'b0)
    );    

    // COMPLETAR: conectar operandos, resultado, flags e índice A.
    // El cast del opcode está provisto.
    assign alu_io.opcode = alu_op_e'(opcode);
endmodule

/*
Lo que realiza es un movimiento de datos a las direcciones queridas. Esto ya se vio y explico en las clases en relacion con el modulo que recibe el resultado de los bancos de registros.
Que se trabaje con un banco de registros significa que por la especificacion cuando insertamos el rd en din con write enable va a tardar el clock de incio, el clock donde se muestra el valor y en el tercer clock de escritura es donde va a ocurrir la modificacion.
En la misma explicacion tambien uno puede ver que esta el clock para inicio, el clock para lectura que es donde se lee el valor y por lo tanto se deja que el destino se sobrescriba o reciba el valor y el clock de write que reemplaza el valor. Estos nombre corresponde con cada una de los estados de los que se pregunta respecto al clock de ejecucion para identificacion (inicio), cuando se actualizan (se ve el valor actual) y cuando se sobre escriben (el write). Estas modificaciones ocurren en cada flanco ascendente y son sobre el A con respecto a escritura (se accede el registry referenciado por A y se ve para modificar este, el registro B se mantiene)
*/
