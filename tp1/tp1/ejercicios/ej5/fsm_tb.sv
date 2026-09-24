`timescale 1ns/1ps
module fsm_tb;
    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick();
        @(posedge clk); #1;
    endtask
    initial begin
        #10000;
        $fatal(1, "TIMEOUT: la simulación no terminó");
    end
    logic rst=1, start=0, ready,done,capture_en,rf_we;
    fsm dut (.*);
    task automatic check(input logic [3:0] expected);
        if ({ready,done,capture_en,rf_we} !== expected)
            $fatal(1, "FSM: ready/done/capture_en/rf_we=%b, esperado=%b",
                   {ready,done,capture_en,rf_we},expected);
    endtask
    initial begin
        $dumpfile("sim.vcd"); $dumpvars;
        tick(); check(4'b1000);
        @(negedge clk); rst=0;
        repeat(2) begin tick(); check(4'b1000); end
        @(negedge clk); start=1; #1; check(4'b1010);
        tick(); check(4'b0000); // FETCH_OPS: segundo ciclo de start ignorado
        tick(); check(4'b0000); // EXECUTE
        @(negedge clk); start=0;
        tick(); check(4'b0101); // WRITEBACK
        tick(); check(4'b1000);
        tick(); check(4'b1000); // no debe haber una orden pendiente
        @(negedge clk); start=1;
        tick();
        @(negedge clk); start=0; rst=1; #1; check(4'b1000);
        $display("PASS ej5: secuencia, captura Mealy, start ocupado y reset"); $finish;
    end

endmodule
