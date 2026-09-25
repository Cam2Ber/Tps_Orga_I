// ============================================================================
// Archivo: fsm.sv
// Descripción: Unidad de Control (FSM). Genera las señales de control de la
//              máquina de estados finitos (IDLE, FETCH_OPS, EXECUTE, WRITEBACK).
//              Estructura de 3 bloques: 1 always_ff (registro de estado) y
//              2 bloques always_comb (lógica de próximo estado y de salidas).
//              Reset activo en alto (rst).
// ============================================================================

/* verilator lint_off IMPORTSTAR */


module fsm (
    input  logic clk,
    input  logic rst,
    input  logic start,
    output logic ready,
    output logic done,
    output logic capture_en,
    output logic rf_we
);

    // Estados de la FSM
    typedef enum logic [1:0] {
        IDLE      = 2'b00,
        FETCH_OPS = 2'b01,
        EXECUTE   = 2'b10,
        WRITEBACK = 2'b11
    } state_e;

    state_e present_state, next_state;

    // Bloque 1: Registro de estado (Sequential Logic)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            present_state <= IDLE;
        end else begin
            present_state <= next_state;
        end
    end

    // Bloque 2: Lógica de próximo estado (Combinational Logic)
    always_comb begin
        next_state = present_state;

        case (present_state)
            IDLE: begin
                if (start) next_state = FETCH_OPS;
            end

            FETCH_OPS: begin
                next_state = EXECUTE;
            end

            EXECUTE: begin
                next_state = WRITEBACK;
            end

            WRITEBACK: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Bloque 3: Lógica de salidas (Combinational Logic)
    always_comb begin
        ready      = 1'b0;
        done       = 1'b0;
        capture_en = 1'b0;
        rf_we      = 1'b0;

        case (present_state)
            IDLE: begin
                ready = 1;
                done = 0;
                capture_en = start;
                rf_we = 0;
            end

            FETCH_OPS: begin
                ready = 0;
                done = 0;
                capture_en = 0;
                rf_we = 0;
            end

            EXECUTE: begin
                ready = 0;
                done = 0;
                capture_en = 0;
                rf_we = 0;
            end

            WRITEBACK: begin
                ready = 0;
                done = 1;
                capture_en = start;
                rf_we = 1;
            end

            default: begin
                ready = 1;
                done = 0;
                capture_en = start;
                rf_we = 0;

                ready = 1'b1;
            end
        endcase
    end

endmodule
