`timescale 1ns/1ns

module RegisterFile (readAddr1, readAddr2, writeAddr, dataIn, writeEn, clk, readOut1, readOut2);

    input[2:0] readAddr1, readAddr2, writeAddr;
    input [11:0] dataIn;
    input writeEn, clk;
    output [11:0] readOut1, readOut2;

    wire [11:0] regRead [7:0];
    wire [7:0] regWriteEn, tempRegWriteEn;
    wire [7:0] inWriteEn;

    Decoder3Bit d1 (writeAddr, tempRegWriteEn);
    buf b1[7:0] (inWriteEn[7:0], writeEn);
    and a1[7:0] (regWriteEn, tempRegWriteEn, inWriteEn);

    reg_12_bit register0 (dataIn, clk, regWriteEn[0], regRead[0]);
    reg_12_bit register1 (dataIn, clk, regWriteEn[1], regRead[1]);
    reg_12_bit register2 (dataIn, clk, regWriteEn[2], regRead[2]);
    reg_12_bit register3 (dataIn, clk, regWriteEn[3], regRead[3]);
    reg_12_bit register4 (dataIn, clk, regWriteEn[4], regRead[4]);
    reg_12_bit register5 (dataIn, clk, regWriteEn[5], regRead[5]);
    reg_12_bit register6 (dataIn, clk, regWriteEn[6], regRead[6]);
    reg_12_bit register7 (dataIn, clk, regWriteEn[7], regRead[7]);

    Multiplexer8to1_12Bit mux1 (regRead[0], regRead[1], regRead[2], regRead[3], regRead[4], regRead[5], regRead[6], regRead[7], readAddr1, readOut1);
    Multiplexer8to1_12Bit mux2 (regRead[0], regRead[1], regRead[2], regRead[3], regRead[4], regRead[5], regRead[6], regRead[7], readAddr2, readOut2);
    
endmodule

module reg_12_bit (dIn, clk, enable, q);

    input [11:0] dIn;
    input clk, enable;
    output [11:0] q;

    dFlipFlop ff[11:0] (dIn[11:0], clk, enable, q[11:0]);

endmodule

module Multiplexer8to1_12Bit(A0, A1, A2, A3, A4, A5, A6, A7, Sel, B);

    input [11:0] A0, A1, A2, A3, A4, A5, A6, A7;
    input [2:0] Sel;
    output [11:0] B;

    wire [2:0] notSel;
    wire [11:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
    not n [2:0] (notSel, Sel);

    and (t0, notSel[0], notSel[1], notSel[2]);
    and a0 [11:0] (temp0, A0, t0);

    and (t1, Sel[0], notSel[1], notSel[2]);
    and a1 [11:0] (temp1, A1, t1);

    and (t2, notSel[0], Sel[1], notSel[2]);
    and a2 [11:0] (temp2, A2, t2);

    and (t3, Sel[0], Sel[1], notSel[2]);
    and a3 [11:0] (temp3, A3, t3);

    and (t4, notSel[0], notSel[1], Sel[2]);
    and a4 [11:0] (temp4, A4, t4);

    and (t5, Sel[0], notSel[1], Sel[2]);
    and a5 [11:0] (temp5, A5, t5);

    and (t6, notSel[0], Sel[1], Sel[2]);
    and a6 [11:0] (temp6, A6, t6);

    and (t7, Sel[0], Sel[1], Sel[2]);
    and a7 [11:0] (temp7, A7, t7);

    or o [11:0] (B,  temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7);

endmodule

module norme (Xe, sel, Ze);

    wire cp;
    input wire sel;
    input wire [3:0] Xe;
    output wire [3:0] Ze;
    wire co;
    wire [3:0] t;
    CLA4Bit c1(Xe, 4'b0000, 1'b1, t, co);
    Multiplexer2to1_4Bit b1(Ze, t, sel, Xe);
    
endmodule

module dFlipFlop (d, clk, enable, q);

    input d, clk, enable;
    output q;

    reg q;

    always @(posedge clk)
        if(enable==1)
            begin
                q = d;
            end
    
endmodule