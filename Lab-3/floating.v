`timescale 1ns/1ns

module fullAdder(A, B, Cin, S, Cout);

    input A, B, Cin;
    output S, Cout;

    xor (S, A, B, Cin);
    and (temp1, A, B);
    and (temp2, B, Cin);
    and (temp3, Cin, A);
    or (Cout, temp1, temp2, temp3);

endmodule

module Adder8Bit(A, B, S);

    input [7:0] A, B;
    output [8:0] S;

    wire [8:0] carry_forward;
    buf (carry_forward[0], 1'b0);

    fullAdder f[7:0] (A[7:0], B[7:0], carry_forward[7:0], S[7:0], carry_forward[8:1]);

    buf (S[8], carry_forward[8]);

endmodule

module Adder4Bit(A, B, S);

    input [3:0] A, B;
    output [3:0] S;

    wire [4:0] carry_forward;
    buf (carry_forward[0], 1'b0);

    fullAdder f[3:0] (A[3:0], B[3:0], carry_forward[3:0], S[3:0], carry_forward[4:1]);

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

module Subtractor4Bit(A, B, D, Bout);

    input [3:0] A, B;
    output [3:0] D;
    output Bout;

    wire [4:0] borrow_forward;
    buf (borrow_forward[0], 1'b0);
    FullSubtractor f[3:0] (A[3:0], B[3:0], borrow_forward[3:0], D[3:0], borrow_forward[4:1]);
    buf (Bout, borrow_forward[4]);

endmodule

module Multiplexer2to1_8Bit(A0, A1, Sel, B);

    input [7:0] A0, A1;
    input Sel;
    output [7:0] B;
    
    wire notSel;
    wire [7:0] temp0, temp1;
    not (notSel, Sel);

    and a0 [7:0] (temp0, A0, notSel);
    and a1 [7:0] (temp1, A1, Sel);
    or o [7:0] (B, temp0, temp1);

endmodule

module Multiplexer2to1_4Bit(A0, A1, Sel, B);

    input [3:0] A0, A1;
    input Sel;
    output [3:0] B;
    
    wire notSel;
    wire [3:0] temp0, temp1;
    not (notSel, Sel);

    and a0 [3:0] (temp0, A0, notSel);
    and a1 [3:0] (temp1, A1, Sel);
    or o [3:0] (B, temp0, temp1);

endmodule

module Multiplexer2to1_7Bit(A0, A1, Sel, B);

    input [6:0] A0, A1;
    input Sel;
    output [6:0] B;
    
    wire notSel;
    wire [6:0] temp0, temp1;
    not (notSel, Sel);

    and a0 [6:0] (temp0, A0, notSel);
    and a1 [6:0] (temp1, A1, Sel);
    or o [6:0] (B, temp0, temp1);

endmodule

module Multiplexer8to1(A0, A1, A2, A3, A4, A5, A6, A7, Sel, B);

    input [7:0] A0, A1, A2, A3, A4, A5, A6, A7;
    input [2:0] Sel;
    output [7:0] B;

    wire [2:0] notSel;
    wire [7:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
    not n [2:0] (notSel, Sel);

    and (t0, notSel[0], notSel[1], notSel[2]);
    and a0 [7:0] (temp0, A0, t0);

    and (t1, Sel[0], notSel[1], notSel[2]);
    and a1 [7:0] (temp1, A1, t1);

    and (t2, notSel[0], Sel[1], notSel[2]);
    and a2 [7:0] (temp2, A2, t2);

    and (t3, Sel[0], Sel[1], notSel[2]);
    and a3 [7:0] (temp3, A3, t3);

    and (t4, notSel[0], notSel[1], Sel[2]);
    and a4 [7:0] (temp4, A4, t4);

    and (t5, Sel[0], notSel[1], Sel[2]);
    and a5 [7:0] (temp5, A5, t5);

    and (t6, notSel[0], Sel[1], Sel[2]);
    and a6 [7:0] (temp6, A6, t6);

    and (t7, Sel[0], Sel[1], Sel[2]);
    and a7 [7:0] (temp7, A7, t7);

    or o [7:0] (B,  temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7);

endmodule

module BarrelShifter8Bit(A, Sel, B);

    input [7:0] A;
    input [2:0] Sel;
    output [7:0] B;

    // Declaring wire variables
    wire [7:0] Ashifted0, Ashifted1, Ashifted2, Ashifted3, Ashifted4, Ashifted5, Ashifted6, Ashifted7;

    /* 
        Initializing shifted values
    */

    // A shifted by 0 bits
    buf b0 [7:0] (Ashifted0[7:0], A[7:0]);

    // A shifted by 1 bits
    buf b2 [6:0] (Ashifted1[6:0], A[7:1]);
    buf b3 [7:7] (Ashifted1[7:7], 1'b0);

    // A shifted by 2 bits
    buf b4 [5:0] (Ashifted2[5:0], A[7:2]);
    buf b5 [7:6] (Ashifted2[7:6], 2'b0);

    // A shifted by 3 bits
    buf b6 [4:0] (Ashifted3[4:0], A[7:3]);
    buf b7 [7:5] (Ashifted3[7:5], 3'b0);

    // A shifted by 4 bits
    buf b8 [3:0] (Ashifted4[3:0], A[7:4]);
    buf b9 [7:4] (Ashifted4[7:4], 4'b0);

    // A shifted by 5 bits
    buf b10 [2:0] (Ashifted5[2:0], A[7:5]);
    buf b11 [7:3] (Ashifted5[7:3], 5'b0);

    // A shifted by 6 bits
    buf b12 [1:0] (Ashifted6[1:0], A[7:6]);
    buf b13 [7:2] (Ashifted6[7:2], 6'b0);

    // A shifted by 7 bits
    buf b14 [0:0] (Ashifted7[0:0], A[7:7]);
    buf b15 [7:1] (Ashifted7[7:1], 7'b0);

    // Using a multiplexer to find the final answer 

    Multiplexer8to1 m (Ashifted0, Ashifted1, Ashifted2, Ashifted3, Ashifted4, Ashifted5, Ashifted6, Ashifted7, Sel, B);

endmodule


module Float_Adder_12bit (X, Y, Z);

    input [11:0] X, Y;
    output [11:0] Z;

    buf (Z[11], 1'b0);

    wire [3:0] K, XE, YE, ZE;

    buf b0[3:0] (XE[3:0], X[10:7]);
    buf b1[3:0] (YE[3:0], Y[10:7]);

    Subtractor4Bit s (XE, YE, K, Bout);

    wire [7:0] temp, Xm, Ym, temp1, Zm;

    buf b2[6:0] (Xm[6:0], X[6:0]);
    buf b3[6:0] (Ym[6:0], Y[6:0]);
    buf (Xm[7], 1'b1);
    buf (Ym[7], 1'b1);

    BarrelShifter8Bit b (Ym[7:0], K[2:0], temp[7:0]);

    Multiplexer2to1_8Bit m (temp[7:0], 8'b0, K[3], temp1[7:0]);

    wire [8:0] Sm;

    Adder8Bit a (Xm[7:0], temp1[7:0], Sm[8:0]);

    Multiplexer2to1_7Bit m1 (Sm[6:0], Sm[7:1], Sm[8], Zm[6:0]);

    wire [3:0] tempe;

    Adder4Bit a1 (XE[3:0], 4'b0001, tempe[3:0]);

    Multiplexer2to1_4Bit m2 (XE[3:0], tempe[3:0], Sm[8], ZE[3:0]);

    buf b4[3:0] (Z[10:7], ZE[3:0]);
    buf b5[6:0] (Z[6:0], Zm[6:0]);

endmodule