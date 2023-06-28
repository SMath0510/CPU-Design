module Test_Bench();

reg[18:0] Ins;
wire[7:0] Out;

CPU uut ( .Ins(Ins), .Out(Out));

initial begin

    // Making the dumpfle and the dumpvars
    $dumpfile("CPU.vcd");
    $dumpvars(0,Test_Bench);

    // Initializing the Instructions such that we explore all the Opcodes
    Ins = 19'b0010010001100010100;
    #15 Ins = 19'b0100010001100010100;
    #15 Ins = 19'b0110010001100010100;
    #15 Ins = 19'b1000010001100010100;
    #15 Ins = 19'b1010010001100010100;
    #15 Ins = 19'b1100010001100010100;
    #15 Ins = 19'b1110010001100010100;
    
    #180 $finish;
end

// displaying the result each time we modify the instruction
always @(Ins) #2 $display("Instruction = %b, OpCode = %b, Operand 1 = %b, Operand 2 = %b, Out = %b", Ins,Ins[18:16], Ins[15:8], Ins[7:0], Out);

endmodule

// Test bed for the CPU module