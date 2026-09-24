`timescale 1ns/1ps
module registro_orden_tb;
    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick();
        @(posedge clk); #1;
    endtask
    initial begin
        #10000;
        $fatal(1, "TIMEOUT: la simulación no terminó");
    end
    logic rst=1, capture_en=0;
    logic [4:0] rs1=0,rs2=0,rd=0,rs1_q,rs2_q,rd_q;
    logic [2:0] opcode=0,op_q;
    registro_orden dut (.*);
    task automatic check(input logic [4:0] a,b,d, input logic [2:0] op);
        if ({rs1_q,rs2_q,rd_q,op_q} !== {a,b,d,op}) $fatal(1, "Orden capturada incorrecta");
    endtask
    initial begin
        $dumpfile("sim.vcd"); $dumpvars;
        tick(); check(0,0,0,0);
        @(negedge clk); rst=0; rs1=1; rs2=2; rd=5; opcode=1;
        tick(); check(0,0,0,0);
        @(negedge clk); capture_en=1; #1; check(0,0,0,0);
        tick(); check(1,2,5,1);
        @(negedge clk); capture_en=0; rs1=8; rs2=9; rd=10; opcode=7;
        repeat(2) begin tick(); check(1,2,5,1); end
        @(negedge clk); capture_en=1;
        tick(); check(8,9,10,7);
        @(negedge clk); rst=1; #1; check(0,0,0,0);
        $display("PASS ej4: captura, retención y reset asíncrono"); $finish;
    end

endmodule
