module CPU(Out,Ins);

    input[18:0] Ins;
    output [7:0] Out;
    wire[7:0] D,a1,a2,a3,a4,a5,a6,a7;
    wire[7:0] t0,t1,t2,t3,t4,t5,t6,t7;

    // Decoding the Opcode
    Decoder d(D,Ins[18:16]);

    // Generating the wires such that they store the results of the operations.
    // The wires a1-a7 hold the result of the operations that are performed by the unit
    add x1[7:0] (a1[7:0] ,Ins[15:8], Ins[7:0]);
    subtract x2[7:0] (a2[7:0] ,Ins[15:8], Ins[7:0]);
    increment x3[7:0] (a3[7:0] ,Ins[15:8]);
    decrement x4[7:0] (a4[7:0] ,Ins[15:8]);
    AND x5[7:0] (a5[7:0] ,Ins[15:8], Ins[7:0]);
    OR x6[7:0] (a6[7:0] ,Ins[15:8], Ins[7:0]);
    NOT x7[7:0] (a7[7:0] ,Ins[15:8]);

    // Here we selectively Make a0-a7 as the output using the Decoded lines
    and g0[7:0] (t0[7:0], 1'b0, D[0]);
    and g1[7:0] (t1[7:0], a1[7:0], D[1]);
    and g2[7:0] (t2[7:0], a2[7:0], D[2]);
    and g3[7:0] (t3[7:0], a3[7:0], D[3]);
    and g4[7:0] (t4[7:0], a4[7:0], D[4]);
    and g5[7:0] (t5[7:0], a5[7:0], D[5]);
    and g6[7:0] (t6[7:0], a6[7:0], D[6]);
    and g7[7:0] (t7[7:0], a7[7:0], D[7]);

    // Combining the results to store into our final Output
    or f[7:0] (Out[7:0],t0[7:0],t1[7:0],t2[7:0],t3[7:0],t4[7:0],t5[7:0],t6[7:0],t7[7:0]);

endmodule

// The main ALU unit that gets the operations done using the opcode and the two operands.


