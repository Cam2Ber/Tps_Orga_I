`timescale 1ns/1ps
module alu_tb;
    import tp1_pkg::*;
    alu_if io ();
    alu dut (.alu_io(io));
    integer checks = 0;
    integer block_checks = 0;
    logic [31:0] block_a, block_b, sum, resta;
    logic cs, vs, cr, vr, iguales, negativo_out;
    sumador_flags u_sum (.a(block_a), .b(block_b), .sum(sum), .carry(cs), .overflow(vs));
    restador_flags u_sub (.a(block_a), .b(block_b), .resta(resta), .carry(cr), .overflow(vr));
    comparador u_cmp (.a(block_a), .b(block_b), .iguales(iguales));
    negativo u_neg (.dato(block_a), .negativo(negativo_out));

    task automatic check_blocks(input logic [31:0] a, b);
        longint signed sa, sb, suma_exacta, resta_exacta;
        longint unsigned ua, ub;
        block_a=a; block_b=b;
        sa=$signed(a); sb=$signed(b); ua={32'b0,a}; ub={32'b0,b};
        suma_exacta=sa+sb; resta_exacta=sa-sb;
        #1;
        if (sum !== 32'(ua+ub) || cs !== ((ua+ub)>64'hffffffff) ||
            vs !== (suma_exacta < -64'sd2147483648 || suma_exacta > 64'sd2147483647))
            $fatal(1,"Sumador provisto: a=%h b=%h",a,b);
        if (resta !== 32'(sa-sb) || cr !== (ua<ub) ||
            vr !== (resta_exacta < -64'sd2147483648 || resta_exacta > 64'sd2147483647))
            $fatal(1,"Restador provisto: a=%h b=%h",a,b);
        if (iguales !== (ua==ub) || negativo_out !== (sa<0))
            $fatal(1,"Comparador o signo: a=%h b=%h",a,b);
        // Comprobar también la ALU contra un oráculo por rango numérico.
        check(OP_ADD,a,b,sum,{sum==0,sum[31],cs,vs});
        check(OP_SUB,a,b,resta,{resta==0,resta[31],cr,vr});
        block_checks++;
    endtask
    task automatic check(input logic [2:0] op, input logic [31:0] a, b, expected,
                         input logic [3:0] flags);
        io.opcode = alu_op_e'(op); io.operand_a = a; io.operand_b = b;
        #1;
        if (io.result !== expected || io.flags !== flags)
            $fatal(1, "ALU op=%0d A=%h B=%h: resultado=%h flags=%b; esperado=%h %b",
                   op, a, b, io.result, io.flags, expected, flags);
        checks++;
    endtask
    initial begin
        logic [31:0] pattern;
        $dumpfile("sim.vcd"); $dumpvars;
        check(OP_ADD, 10, 20, 30, 4'b0000);
        check(OP_ADD, 32'hffffffff, 1, 0, 4'b1010);
        check(OP_ADD, 32'h7fffffff, 1, 32'h80000000, 4'b0101);
        check(OP_ADD, 32'h80000000, 32'h80000000, 0, 4'b1011);
        check(OP_SUB, 10, 20, 32'hfffffff6, 4'b0110);
        check(OP_SUB, 10, 10, 0, 4'b1000);
        check(OP_SUB, 20, 10, 10, 4'b0000);
        check(OP_SUB, 32'h80000000, 1, 32'h7fffffff, 4'b0001);
        check(OP_SUB, 32'h7fffffff, 32'hffffffff, 32'h80000000, 4'b0111);
        check(OP_AND, 32'hfffffffb, 32'h80000000, 32'h80000000, 4'b0100);
        check(OP_AND, 10, 20, 0, 4'b1000);
        check(OP_OR, 10, 20, 30, 4'b0000);
        check(OP_OR, 32'h80000000, 0, 32'h80000000, 4'b0100);
        check(OP_OR, 0, 0, 0, 4'b1000);
        for (int op=4; op<8; op++) check(3'(op), 10, 20, 0, 4'b0100);
        // Todos los bits del comparador y ambos extremos del rango signed.
        check_blocks(0,0);
        check_blocks(32'h7fffffff,1);
        check_blocks(32'h80000000,1);
        check_blocks(32'hffffffff,1);
        check_blocks(32'h80000000,32'hffffffff);
        for (int bit_idx=0;bit_idx<32;bit_idx++) begin
            pattern=32'b1 << bit_idx;
            check_blocks(pattern,pattern); // igualdad no nula
            check_blocks(pattern,0);
        end
        pattern=32'h12345678;
        repeat (128) begin
            pattern=pattern*32'd1664525+32'd1013904223;
            check_blocks(pattern,pattern^32'hcafe9876);
        end
        $display("PASS componentes: %0d pares de 32 bits",block_checks);
        $display("PASS ej1: %0d casos de ALU", checks); $finish;
    end

endmodule
