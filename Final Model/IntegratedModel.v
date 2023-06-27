`timescale 1ns/1ns

module ALU(instruction, ALU_output);

    input [26:0] instruction;
    output [11:0] ALU_output;
    wire [2:0] opcode = instruction[26:24];
    wire [11:0] operand1 = instruction[23:12];
    wire [11:0] operand2 = instruction[11:0];
    wire [7:0] Sel;

    Decoder3Bit decoder (opcode, Sel);

    wire [11:0] intAdderOut, intSubtractorOut, unsignMultiplierOut, signMultiplierOut;
    wire [11:0] floatMultiplierOut, floatAdderOut, compOut;

    Adder8Bit adder1 (operand1[7:0], operand2[7:0], 1'b0, intAdderOut[7:0], temp); // calculate adder output
    buf buf1[3:0] (intAdderOut[11:8], 1'b0);
    Subtractor8Bit subtractor1 (operand1[7:0], operand2[7:0], 1'b0, intSubtractorOut[7:0], temp); // calculate subtractor output
    buf buf2[3:0] (intSubtractorOut[11:8], 1'b0);
    wire [15:0] product;
    Multiplier8Bit_Unsigned mul1 (operand1[7:0], operand2[7:0], product[15:0], temp);
    buf buf10[7:0] (unsignMultiplierOut[7:0], product[7:0]);
    buf buf3[3:0] (unsignMultiplierOut[11:8], 1'b0);
    Multiplier8Bit_Signed mul2 (operand1[7:0], operand2[7:0], signMultiplierOut[7:0], temp);
    buf buf4[3:0] (signMultiplierOut[11:8], 1'b0);
    Float_Adder_12bit fadder1 (operand1, operand2, floatAdderOut);
    Floating_Multiplier fmul1 (operand1, operand2, floatMultiplierOut);
    Comparator8Bit comp1 (operand1[7:0], operand2[7:0], compOut[7:0]);
    buf buf5[3:0] (compOut[11:8], 1'b0);

    //extending each select bit to 8-bit length so that an AND operation can be exexuted
    wire [11:0] Sel0, Sel1, Sel2, Sel3, Sel4, Sel5, Sel6, Sel7, select_adder;
    buf b0[11:0] (Sel0, Sel[0]);
    buf b1[11:0] (Sel1, Sel[1]);
    buf b2[11:0] (Sel2, Sel[2]);
    buf b3[11:0] (Sel3, Sel[3]);
    buf b4[11:0] (Sel4, Sel[4]);
    buf b5[11:0] (Sel5, Sel[5]);
    buf b6[11:0] (Sel6, Sel[6]);
    buf b7[11:0] (Sel7, Sel[7]);

    wire [11:0] op1, op2, op3, op4, op5, op6, op7;
    and and0[11:0] (op1, intAdderOut, Sel1);
    and and1[11:0] (op2, intSubtractorOut, Sel2);
    and and2[11:0] (op3, unsignMultiplierOut, Sel3);
    and and3[11:0] (op4, signMultiplierOut, Sel4);
    and and4[11:0] (op5, floatAdderOut, Sel5);
    and and5[11:0] (op6, floatMultiplierOut, Sel6);
    and and6[11:0] (op7, compOut, Sel7);
    
    or or1[11:0] (ALU_output, op1, op2, op3, op4, op5, op6, op7);

endmodule

module Decoder3Bit(opcode, Sel); 

    input [2:0] opcode;
    output [7:0] Sel;
    wire [2:0] opcode_bar; //this stores the values of the complements of the input opcode bits
    not nots[2:0] (opcode_bar[2:0], opcode[2:0]);

    and and0 (Sel[0], opcode_bar[2], opcode_bar[1], opcode_bar[0]); //opcode = 000 
    and and1 (Sel[1], opcode_bar[2], opcode_bar[1], opcode[0]); //opcode = 001
    and and2 (Sel[2], opcode_bar[2], opcode[1], opcode_bar[0]); //opcode = 010
    and and3 (Sel[3], opcode_bar[2], opcode[1], opcode[0]); //opcode = 011
    and and4 (Sel[4], opcode[2], opcode_bar[1], opcode_bar[0]); //opcode = 100
    and and5 (Sel[5], opcode[2], opcode_bar[1], opcode[0]); //opcode = 101
    and and6 (Sel[6], opcode[2], opcode[1], opcode_bar[0]); //opcode = 110
    and and7 (Sel[7], opcode[2], opcode[1], opcode[0]); //opcode = 111

endmodule

module Comparator8Bit (A, B, C);

    input [7:0] A, B;
    output [7:0] C;
    xor x11 [7:0] (C, A, B);

endmodule

module halfAdder(A, B, sum, carry);

    input A,B;
    output sum,carry;

    and (carry, A, B);
    xor (sum, A, B);

endmodule;

module Increment16Bit(A, Aplus1, carry);

    input [15:0] A;
    output [15:0] Aplus1;
    output carry;

    wire [16:0] carry_forward;
    assign carry_forward[0] = 1;

    halfAdder h[15:0] (A[15:0], carry_forward[15:0], Aplus1[15:0], carry_forward[16:1]);
    buf(carry,carry_forward[16]);

endmodule

module CLA4Bit(A, B, C, sum, carry);

    input [3:0] A, B;
    input C;
    output [3:0] sum;
    output carry;

    wire [3:0] p, g;
    and a[3:0] (g[3:0], A[3:0], B[3:0]);
    xor x[3:0] (p[3:0], A[3:0], B[3:0]);

    wire car[4:0];
    buf (car[0], C);
    xor (sum[0], car[0], p[0]);

    // C1
    and (t1, p[0], C);
    or (car[1], g[0], t1);
    xor (sum[1], car[1], p[1]);

    // C2
    and (t2, p[0], p[1], C);
    and (t3, p[1], g[0]);
    or (car[2], g[1], t2, t3);
    xor (sum[2], car[2], p[2]);

    // C3
    and (t4, p[0], p[1], p[2], C);
    and (t5, p[1], p[2], g[0]);
    and (t6, p[2], g[1]);
    or (car[3], g[2], t4, t5, t6);
    xor (sum[3], car[3], p[3]);

    // C4
    and (t7, p[3], p[2], p[1], p[0], C);
    and (t8, p[3], p[2], p[1], g[0]);
    and (t9, p[3], p[2], g[1]);
    and (t10, p[3], g[2]);
    or (car[4], g[3], t7, t8, t9, t10);

    buf (carry, car[4]);

endmodule

module CLA4Bit_Generate(A, B, P, G);

    input [3:0] A, B;
    output P, G;

    wire [3:0] p, g;
    and a[3:0] (g[3:0], A[3:0], B[3:0]);
    xor x[3:0] (p[3:0], A[3:0], B[3:0]);

    // P
    and (P, p[0], p[1], p[2], p[3]);

    // G
    and (t1, p[3], p[2], p[1], g[0]);
    and (t2, p[3], p[2], g[1]);
    and (t3, p[3], g[2]);
    or (G, g[3], t1, t2, t3);

endmodule

module CLA16Bit(A, B, C, sum, carry);

    input [15:0] A, B;
    input C;
    output [15:0] sum;
    output carry;

    wire carry_forward [4:0];
    buf(carry_forward[0], C);
    CLA4Bit c1(A[3:0], B[3:0], carry_forward[0], sum[3:0], carry_forward[1]);
    CLA4Bit c2(A[7:4], B[7:4], carry_forward[1], sum[7:4], carry_forward[2]);
    CLA4Bit c3(A[11:8], B[11:8], carry_forward[2], sum[11:8], carry_forward[3]);
    CLA4Bit c4(A[15:12], B[15:12], carry_forward[3], sum[15:12], carry_forward[4]);

    buf(carry, carry_forward[4]);

endmodule

module CLA16Bit_HigherOrder(A, B, C, sum, carry);

    input [15:0] A, B;
    input C;
    output [15:0] sum;
    output carry;

    wire p0, p4, p8, p12;
    wire c0, c4, c8, c12;

    //Generating Higher Order Terms
    CLA4Bit_Generate cg1(A[3:0], B[3:0], p0, g0);
    CLA4Bit_Generate cg2(A[7:4], B[7:4], p4, g4);
    CLA4Bit_Generate cg3(A[11:8], B[11:8], p8, g8);
    CLA4Bit_Generate cg4(A[15:12], B[15:12], p12, g12);

    // C4
    and (t1, p0, C);
    or (c4, g0, t1);

    // C8
    and (t2, p0, p4, C);
    and (t3, p4, g0);
    or (c8, g4, t2, t3);

    // C12 
    and (t4, p0, p4, p8, C);
    and (t5, p4, p8, g0);
    and (t6, p8, g4);
    or (c12, g8, t4, t5, t6);

    // C16
    and (t7, p0, p4, p8, p12, C);
    and (t8, p4, p8, p12, g0);
    and (t9, p8, p12, g4);
    and (t10, p12, g8);
    or (c16, g12, t7, t8, t9, t10);

    CLA4Bit cc1(A[3:0], B[3:0], C, sum[3:0], temp1);
    CLA4Bit cc2(A[7:4], B[7:4], c4, sum[7:4], temp2);
    CLA4Bit cc3(A[11:8], B[11:8], c8, sum[11:8], temp3);
    CLA4Bit cc4(A[15:12], B[15:12], c12, sum[15:12], temp4);

    buf (carry, c16);

endmodule

module CLS16Bit(A, B, C, diff, carry);

    input [15:0] A, B;
    input C;
    output [15:0] diff;
    output carry;

    wire [15:0] D, E;
    wire carry_temp;
    not n[15:0] (D[15:0], B[15:0]);
    Increment16Bit i[15:0] (D[15:0], E[15:0], carry_temp);
    
    CLA16Bit c1(A, E, C, diff, carry);

endmodule

module CLS16Bit_HigherOrder(A, B, C, diff, carry);

    input [15:0] A, B;
    input C;
    output [15:0] diff;
    output carry;

    wire [15:0] D, E;
    wire carry_temp;
    not n[15:0] (D[15:0], B[15:0]);
    Increment16Bit i[15:0] (D[15:0], E[15:0], carry_temp);
    
    CLA16Bit_HigherOrder c1(A, E, C, diff, carry);

endmodule


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

module Adder8Bit(A, B, C, S, carry);

    input [7:0] A, B;
    input C;
    output [7:0] S;
    output carry;

    wire [8:0] carry_forward;
    buf (carry_forward[0], C);

    fullAdder f[7:0] (A[7:0], B[7:0], carry_forward[7:0], S[7:0], carry_forward[8:1]);

    buf (carry, carry_forward[8]);

endmodule

module Adder4Bit(A, B, S);

    input [3:0] A, B;
    output [3:0] S;

    wire [4:0] carry_forward;
    buf (carry_forward[0], 1'b0);

    fullAdder f[3:0] (A[3:0], B[3:0], carry_forward[3:0], S[3:0], carry_forward[4:1]);

endmodule

module Adder4BitSpecial(A, B, C, S, carry);

    input [3:0] A, B;
    input C;
    output [3:0] S;
    output carry;

    wire [4:0] carry_forward;
    buf (carry_forward[0], C);

    fullAdder f[3:0] (A[3:0], B[3:0], carry_forward[3:0], S[3:0], carry_forward[4:1]);
    buf (carry, carry_forward[4]);

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

/* Floating Point Arithmetic */

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

module Subtractor8Bit(A, B, C, D, Bout);

    input [7:0] A, B;
    input C;
    output [7:0] D;
    output Bout;

    wire [8:0] borrow_forward;
    buf (borrow_forward[0], C);
    FullSubtractor f[7:0] (A[7:0], B[7:0], borrow_forward[7:0], D[7:0], borrow_forward[8:1]);
    buf (Bout, borrow_forward[8]);

endmodule

module Subtractor5Bit(A, B, D);

    input [4:0] A, B;
    output [4:0] D;

    wire [5:0] borrow_forward;
    buf (borrow_forward[0], 1'b0);
    FullSubtractor f[4:0] (A[4:0], B[4:0], borrow_forward[4:0], D[4:0], borrow_forward[5:1]);

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
    wire carry;
    Adder8Bit a (Xm[7:0], temp1[7:0], 1'b0, Sm[7:0], carry);
    buf (Sm[8], carry);

    Multiplexer2to1_7Bit m1 (Sm[6:0], Sm[7:1], Sm[8], Zm[6:0]);

    wire [3:0] tempe;

    Adder4Bit a1 (XE[3:0], 4'b0001, tempe[3:0]);

    Multiplexer2to1_4Bit m2 (XE[3:0], tempe[3:0], Sm[8], ZE[3:0]);

    buf b4[3:0] (Z[10:7], ZE[3:0]);
    buf b5[6:0] (Z[6:0], Zm[6:0]);

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
    
    wire carry;
    Adder4BitSpecial A1(X[10:7], Y[10:7], 1'b0, Ze_temp[3:0], carry);
    buf (Ze_temp[4], carry);

    Subtractor5Bit S1(Ze_temp[4:0], Bias[4:0], Out1[4:0]);
    Subtractor5Bit S2(Ze_temp[4:0], BiasL[4:0], Out2[4:0]);
    Multiplexer2to1_4Bit M3(Out1[3:0], Out2[3:0], Pm[15], Z[10:7]);

    xor (Z[11], X[11], Y[11]);

endmodule
