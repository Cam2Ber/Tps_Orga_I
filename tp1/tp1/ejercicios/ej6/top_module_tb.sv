`timescale 1ns/1ps
module top_module_tb;
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
    logic rst=1,start=0,ready,done;
    logic [4:0] rs1=0,rs2=0,rd=0;
    logic [2:0] opcode=0;
    alu_flags_t alu_flags;
    top_module dut (.*);
    integer checks=0;
    task automatic operation(input logic [4:0] a,b,d, input logic [2:0] op,
                             input logic [31:0] expected, input logic [3:0] expected_flags);
        logic [31:0] previous;
        if (ready !== 1 || done !== 0) $fatal(1,"Unidad no disponible");
        previous=dut.u_datapath.u_reg_file.rf[d];
        @(negedge clk); rs1=a; rs2=b; rd=d; opcode=op; start=1;
        tick(); // captura -> FETCH_OPS
        if (ready !== 0 || done !== 0) $fatal(1,"Protocolo al capturar");
        // Cambiar TODA la orden, manteniendo start un segundo ciclo.
        @(negedge clk); rs1=31; rs2=31; rd=31; opcode=7;
        tick(); // EXECUTE
        if (ready !== 0 || done !== 0) $fatal(1,"Protocolo EXECUTE");
        @(negedge clk); start=0;
        tick(); // WRITEBACK; todavía no ocurrió el flanco de escritura
        if (ready !== 0 || done !== 1) $fatal(1,"done debe indicar WRITEBACK");
        if (dut.result !== expected || alu_flags !== expected_flags)
            $fatal(1,"Resultado/flags: %h %b, esperado: %h %b",dut.result,alu_flags,expected,expected_flags);
        if (dut.u_datapath.u_reg_file.rf[d] !== previous) $fatal(1,"Escritura prematura");
        tick(); // escritura -> IDLE
        if (ready !== 1 || done !== 0) $fatal(1,"Protocolo al terminar");
        if (d != 0 && dut.u_datapath.u_reg_file.rf[d] !== expected)
            $fatal(1,"R%0d: esperado=%h obtenido=%h",d,expected,dut.u_datapath.u_reg_file.rf[d]);
        tick();
        if (ready !== 1 || done !== 0 || dut.u_datapath.u_reg_file.rf[31] !== 32'h12345678)
            $fatal(1,"Se aceptó una orden mientras estaba ocupado");
        checks++;
    endtask
    initial begin
        $dumpfile("sim.vcd"); $dumpvars;
        tick(); @(negedge clk); rst=0;
        for (int i=0;i<32;i++) dut.u_datapath.u_reg_file.rf[i]=0;
        dut.u_datapath.u_reg_file.rf[1]=10;
        dut.u_datapath.u_reg_file.rf[2]=20;
        dut.u_datapath.u_reg_file.rf[3]=32'hfffffffb;
        dut.u_datapath.u_reg_file.rf[4]=32'h80000000;
        dut.u_datapath.u_reg_file.rf[12]=32'h7fffffff;
        dut.u_datapath.u_reg_file.rf[13]=1;
        dut.u_datapath.u_reg_file.rf[14]=32'hffffffff;
        dut.u_datapath.u_reg_file.rf[31]=32'h12345678;
        #1;
        operation(1,2,5,OP_ADD,30,4'b0000);
        if (dut.u_datapath.u_reg_file.rf[1] !== 10 || dut.u_datapath.u_reg_file.rf[2] !== 20) $fatal(1,"Origen modificado");
        operation(5,1,6,OP_SUB,20,4'b0000);
        operation(1,2,6,OP_SUB,32'hfffffff6,4'b0110);
        operation(1,1,7,OP_SUB,0,4'b1000);
        operation(3,4,8,OP_AND,32'h80000000,4'b0100);
        operation(1,2,9,OP_OR,30,4'b0000);
        operation(1,2,0,OP_ADD,30,4'b0000);
        operation(0,0,10,OP_ADD,0,4'b1000);
        operation(1,2,11,7,0,4'b0100);
        operation(12,13,15,OP_ADD,32'h80000000,4'b0101);
        operation(4,13,16,OP_SUB,32'h7fffffff,4'b0001);
        operation(14,13,17,OP_ADD,0,4'b1010);
        operation(1,2,1,OP_ADD,30,4'b0000);
        operation(1,13,1,OP_SUB,29,4'b0000);
        $display("PASS ej6: %0d operaciones, escritura, flags, captura y protocolo",checks); $finish;
    end

endmodule
