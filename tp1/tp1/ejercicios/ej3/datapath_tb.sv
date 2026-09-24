`timescale 1ns/1ps
module datapath_tb;
    logic clk = 0;
    always #5 clk = ~clk;
    task automatic tick();
        @(posedge clk); #1;
    endtask
    initial begin
        #10000;
        $fatal(1, "TIMEOUT: la simulación no terminó");
    end
    import tp1_pkg::*;
    logic rst=1, rf_we=0;
    logic [4:0] rs1=0, rs2=0, rd=0;
    logic [2:0] opcode=0;
    logic [31:0] result;
    alu_flags_t flags;
    datapath dut (.*);
    task automatic operation(input logic [4:0] a,b,d, input logic [2:0] op,
                             input logic [31:0] expected, input logic [3:0] expected_flags);
        @(negedge clk); rs1=a; rs2=b; rd=d; opcode=op; rf_we=0;
        tick();
        if (result !== expected || flags !== expected_flags)
            $fatal(1, "Datapath: resultado=%h flags=%b; esperado=%h %b", result, flags, expected, expected_flags);
        @(negedge clk); rf_we=1; #1;
        if (dut.regA_idx !== d || result !== expected) $fatal(1, "Mux de destino o dato inestable antes de escritura");
        tick();
        if (d != 0 && dut.u_reg_file.rf[d] !== expected) $fatal(1, "No se escribió R%0d", d);
        @(negedge clk); rf_we=0;
    endtask
    initial begin
        $dumpfile("sim.vcd"); $dumpvars;
        tick(); @(negedge clk); rst=0;
        for (int i=0;i<32;i++) dut.u_reg_file.rf[i]=0;
        dut.u_reg_file.rf[1]=10; dut.u_reg_file.rf[2]=20;
        operation(1,2,5,OP_ADD,30,4'b0000);
        if (dut.u_reg_file.rf[1] !== 10 || dut.u_reg_file.rf[2] !== 20) $fatal(1, "Se modificó un origen");
        operation(5,1,6,OP_SUB,20,4'b0000);
        operation(1,2,0,OP_ADD,30,4'b0000);
        operation(0,0,7,OP_ADD,0,4'b1000);
        operation(1,2,1,OP_OR,30,4'b0000);
        $display("PASS ej3: cálculo, escritura, dependencia y destino igual a origen"); $finish;
    end

endmodule
