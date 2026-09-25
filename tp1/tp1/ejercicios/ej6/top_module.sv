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
