`timescale 1ns/1ns

// 4 bits for biased exponent
// 7 bits for mantisa
// 1 bit for sign

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

module Adder4Bit(A, B, sum);

    input [3:0] A, B;
    output [4:0] sum;

    wire [4:0] carry_forward;
    buf(carry_forward[0], 1'b0);
    fullAdder f[3:0] (A[3:0], B[3:0], carry_forward[3:0], sum[3:0], carry_forward[4:1]);
    buf (sum[4], carry_forward[4]);

endmodule

module FullSubtractor(A, B, Bin, D, Bout);

    input A, B, Bin;
    output D, Bout;

    xor (D, A, B, Bin);
    not (Abar, A);
    and (temp1, Abar, B);
    and (temp2, Abar, Bin);
    and (temp3, B, Bin);
    or (Bout, temp1, temp2, temp3);

endmodule

module Subtractor5Bit(A, B, D);

    input [4:0] A, B;
    output [4:0] D;

    wire [5:0] borrow_forward;
    buf (borrow_forward[0], 1'b0);
    FullSubtractor f[4:0] (A[4:0], B[4:0], borrow_forward[4:0], D[4:0], borrow_forward[5:1]);

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

module Multiplexer2to1_7Bit(A1, A2, Sel, B);

    input [6:0] A1, A2;
    input Sel;
    output [6:0] B;
    
    wire notSel;
    wire [6:0] temp1, temp2;
    not (notSel, Sel);

    and a0 [6:0] (temp1[6:0], A1[6:0], notSel);
    and a1 [6:0] (temp2[6:0], A2[6:0], Sel);
    or o [6:0] (B[6:0],  temp1[6:0], temp2[6:0]);

endmodule

module Multiplexer2to1_4Bit(A1, A2, Sel, B);

    input [3:0] A1, A2;
    input Sel;
    output [3:0] B;
    
    wire notSel;
    wire [3:0] temp1, temp2;
    not (notSel, Sel);

    and a0 [3:0] (temp1[3:0], A1[3:0], notSel);
    and a1 [3:0] (temp2[3:0], A2[3:0], Sel);
    or o [3:0] (B[3:0], temp1[3:0], temp2[3:0]);

endmodule

module Floating_Multiplier(X, Y, Z);

    input [11:0] X, Y;
    output [11:0] Z;
    wire [7:0] Xm_temp, Ym_temp;
    wire [15:0] Pm;
    wire [4:0] Bias, BiasL, Out1, Out2;
    wire [4:0] Ze_temp;
    wire O;

    buf (Xm_temp[7], 1'b1);
    buf (Ym_temp[7], 1'b1);
    buf b1[6:0] (Ym_temp[6:0], Y[6:0]);
    buf b2[6:0] (Xm_temp[6:0], X[6:0]);

    buf b3[4:0] (Bias[4:0], 5'b00111);
    buf b4[4:0] (BiasL[4:0], 5'b00110);

    Multiplier8Bit_Unsigned M1(Xm_temp, Ym_temp, Pm, O);
    Multiplexer2to1_7Bit M2(Pm[13:7], Pm[14:8], Pm[15], Z[6:0]);
    
    Adder4Bit A1(X[10:7], Y[10:7], Ze_temp[4:0]);
    Subtractor5Bit S1(Ze_temp[4:0], Bias[4:0], Out1[4:0]);
    Subtractor5Bit S2(Ze_temp[4:0], BiasL[4:0], Out2[4:0]);
    Multiplexer2to1_4Bit M3(Out1[3:0], Out2[3:0], Pm[15], Z[10:7]);

    xor (Z[11], X[11], Y[11]);

endmodule
