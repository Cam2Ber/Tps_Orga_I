`timescale 1ns/1ps
module reg_file_tb;
    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick();
        @(posedge clk); #1;
    endtask
    initial begin
        #10000;
        $fatal(1, "TIMEOUT: la simulación no terminó");
    end
    logic rst = 1, regA_we = 0, regB_we = 0;
    logic [4:0] regA_idx = 0, regB_idx = 0;
    logic [31:0] regA_din = 0, regB_din = 0, regA_dout, regB_dout;
    reg_file dut (.*);
    initial begin
        $dumpfile("sim.vcd"); $dumpvars;
        tick();
        if (regA_dout !== 0 || regB_dout !== 0) $fatal(1, "Reset de salidas");
        @(negedge clk); rst=0; regA_idx=1; regA_din=10; regA_we=1;
        regB_idx=2; regB_din=20; regB_we=1;
        tick();
        @(negedge clk); regA_we=0; regB_we=0;
        tick();
        if (regA_dout !== 10 || regB_dout !== 20) $fatal(1, "Lectura de R1/R2");
        @(negedge clk); regA_idx=2; #1;
        if (regA_dout !== 10) $fatal(1, "La lectura debe esperar al flanco");
        tick();
        if (regA_dout !== 20) $fatal(1, "Cambio de índice no leído");
        @(negedge clk); regA_din=99; regA_we=1;
        tick();
        if (regA_dout !== 20 || regB_dout !== 20) $fatal(1, "Read-first: ambos puertos leen el valor anterior");
        @(negedge clk); regA_we=0;
        tick();
        if (regA_dout !== 99 || regB_dout !== 99) $fatal(1, "Escritura de R2");
        @(negedge clk); regA_idx=0; regB_idx=0; regA_we=1; regB_we=1;
        regA_din=123; regB_din=456;
        tick();
        if (regA_dout !== 0 || regB_dout !== 0) $fatal(1, "R0 debe leerse como cero");
        @(negedge clk); regA_we=0; regB_we=0;
        tick();
        if (regA_dout !== 0 || regB_dout !== 0) $fatal(1, "R0 después de escritura");
        $display("PASS ej2: lectura síncrona, escritura, read-first y R0"); $finish;
    end

endmodule
