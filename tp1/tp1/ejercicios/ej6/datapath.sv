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
