`timescale 1ns/1ns

module fullAdder(A, B, C, sum, carry);

    input A,B,C;
    output sum, carry;

    xor(sum, A, B, C);
    and(t1, A, B);
    and(t2, B, C);
    and(t3, C, A);
    or(carry, t1, t2, t3);

endmodule

module Adder16Bit(A, B, sum, carry);

    input [15:0] A, B;
    output [15:0] sum;
    output carry;

    wire [16:0] carry_forward;
    buf(carry_forward[0], 1'b0);
    fullAdder f[15:0] (A[15:0], B[15:0], carry_forward[15:0], sum[15:0], carry_forward[16:1]);
    buf(carry, carry_forward[16]);

endmodule

module Complement8Bit (A, M, B);

    input  [7:0] A;
    input M;
    output [7:0] B;

    wire [7:0] temp, second;
    wire [8:0] carry_forward;
    
    buf b[7:0] (second, 8'b0);
    buf (carry_forward[0], M);

    xor x[7:0] (temp[7:0], A[7:0], M);
    fullAdder f[7:0] (temp, second, carry_forward[7:0], B, carry_forward[8:1]);

endmodule

module Complement16Bit (A, M, B);

    input  [15:0] A;
    input M;
    output [15:0] B;

    wire [15:0] temp, second;
    wire [16:0] carry_forward;
    
    buf b[15:0] (second, 16'b0);
    buf (carry_forward[0], M);

    xor x[15:0] (temp[15:0], A[15:0], M);
    fullAdder f[15:0] (temp, second, carry_forward[15:0], B, carry_forward[16:1]);

endmodule

module Multiplier8Bit_Unsigned(A, B, P, O);

    input [7:0] A;
    input [7:0] B;
    output [15:0] P;
    output O;

    // Adding additional zeroes to the start of A & B
    wire [15:0] Ashifted, Bshifted;
    buf b1[7:0] (Ashifted[15:8], 8'b0);
    buf b2[7:0] (Bshifted[15:8], 8'b0);
    buf b3[7:0] (Ashifted[7:0], A[7:0]);
    buf b4[7:0] (Bshifted[7:0], B[7:0]);

    /*
        Computing Partial Products
    */

    //Intiializing all partial products
    wire [15:0] PP0, PP1, PP2, PP3, PP4, PP5, PP6, PP7;
        
    //Calculating the actual partial product && filling remaining places with zeroes
    and a0[7:0] (PP0[7:0], Ashifted[7:0], Bshifted[0]);
    buf b5[15:8] (PP0[15:8], 8'b0);

    and a1[7:0] (PP1[8:1], Ashifted[7:0], Bshifted[1]);
    buf b6[15:9] (PP1[15:9], 7'b0);
    buf (PP1[0], 1'b0);

    and a2[7:0] (PP2[9:2], Ashifted[7:0], Bshifted[2]);
    buf b7[15:10] (PP2[15:10], 6'b0);
    buf b8[1:0] (PP2[1:0], 2'b0);

    and a3[7:0] (PP3[10:3], Ashifted[7:0], Bshifted[3]);
    buf b9[15:11] (PP3[15:11], 5'b0);
    buf b10[2:0] (PP3[2:0], 3'b0);

    and a4[7:0] (PP4[11:4], Ashifted[7:0], Bshifted[4]);
    buf b11[15:12] (PP4[15:12], 4'b0);
    buf b12[3:0] (PP4[3:0], 4'b0);

    and a5[7:0] (PP5[12:5], Ashifted[7:0], Bshifted[5]);
    buf b13[15:13] (PP5[15:13], 3'b0);
    buf b14[4:0] (PP5[4:0], 5'b0);

    and a6[7:0] (PP6[13:6], Ashifted[7:0], Bshifted[6]);
    buf b15[15:14] (PP6[15:14], 2'b0);
    buf b16[5:0] (PP6[5:0], 6'b0);

    and a7[7:0] (PP7[14:7], Ashifted[7:0], Bshifted[7]);
    buf (PP7[15], 1'b0);
    buf b17[6:0] (PP7[6:0], 7'b0);

    // Declaring all the temporary sums & carries
    wire[15:0] S10, C10, S11, C11, S20, C20, S21, C21, S30, C30, S40, C40;

    // Initializing parts of them to zero
    buf b18[15:10] (S10[15:10], 6'b0);
    buf b19[15:11] (C10[15:11], 5'b0);
    buf (C10[0], 1'b0);

    buf b20[15:13] (S11[15:13], 3'b0);
    buf b21[15:14] (C11[15:14], 2'b0);
    buf (C11[0], 1'b0);

    buf b22[15:13] (S20[15:13], 3'b0);
    buf b23[15:14] (C20[15:14], 2'b0);
    buf (C20[0], 1'b0);

    buf (S21[15], 1'b0);
    buf (C21[0], 1'b0);

    buf (S30[15], 1'b0);
    buf (C30[0], 1'b0);

    buf (S40[15], 1'b0);
    buf (C40[0], 1'b0);

    /*
        First Level
    */

    // First Reducer
    fullAdder f1[9:0] (PP0[9:0], PP1[9:0], PP2[9:0], S10[9:0], C10[10:1]);

    // Second Reducer
    fullAdder f2[12:0] (PP3[12:0], PP4[12:0], PP5[12:0], S11[12:0], C11[13:1]);

    /*
        Second Level
    */

    // First Reducer
    fullAdder f3[12:0] (S10[12:0], C10[12:0], C11[12:0], S20[12:0], C20[13:1]);

    // Second Reducer
    fullAdder f4[14:0] (S11[14:0], PP6[14:0], PP7[14:0], S21[14:0], C21[15:1]);

    /*
        Third Level
    */

    //First Reducer
    fullAdder f5[14:0] (C20[14:0], S20[14:0], C21[14:0], S30[14:0], C30[15:1]);

    /* 
        Fourth Level
    */

    // First Reducer
    fullAdder f6[14:0] (C30[14:0], S30[14:0], S21[14:0], S40[14:0], C40[15:1]);

    /*
        Final Addition using 16 Bit Adder
    */

    Adder16Bit a(S40[15:0], C40[15:0], P[15:0], temp);

    // Computing the overflow flag
    or (O, P[15], P[14], P[13], P[12], P[11], P[10], P[9], P[8]);

endmodule

module Multiplier8Bit_Signed(A, B, P, O);

    input [7:0] A, B;
    output [7:0] P;
    output O;

    wire [7:0] Bcomplement, Acomplement;
    wire oldSignedA, oldSignedB;
    buf (oldSignedA, A[7]);
    buf (oldSignedB, B[7]);

    Complement8Bit c1 (A, oldSignedA, Acomplement);
    Complement8Bit c2 (B, oldSignedB, Bcomplement);

    wire [15:0] tempP, finalP, notfinalP;
    Multiplier8Bit_Unsigned m(Acomplement, Bcomplement, tempP, OO);
    wire xorSign;
    xor (xorSign, oldSignedA, oldSignedB);
    Complement16Bit c3 (tempP, xorSign, finalP);
    buf b[7:0] (P, finalP[7:0]);
    
    // Computing the Overflow flag
    xor (overflow1, oldSignedA, oldSignedB);
    xnor (overflow2, oldSignedA, oldSignedB);
    or (tempo1, finalP[15], finalP[14], finalP[13], finalP[12], finalP[11], finalP[10], finalP[9], finalP[8]);
    not n[15:0] (notfinalP, finalP);
    or (tempo2, notfinalP[15], notfinalP[14], notfinalP[13], notfinalP[12], notfinalP[11], notfinalP[10], notfinalP[9], notfinalP[8]);
    and (overflow3, overflow2, tempo1);
    and (overflow4, overflow1, tempo2);
    or (O, overflow3, overflow4);
    
endmodule