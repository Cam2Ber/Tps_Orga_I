// Guarda índices, no contenidos del banco.
module registro_orden (
    input logic clk, rst, capture_en,
    input logic [4:0] rs1, rs2, rd,
    input logic [2:0] opcode,
    output logic [4:0] rs1_q, rs2_q, rd_q,
    output logic [2:0] op_q
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rs1_q <= '0;
            rs2_q <= '0;
            rd_q <= '0;
            op_q <= '0;
        end else if (capture_en) begin
            // COMPLETAR: guardar la orden.
        end
    end
endmodule
