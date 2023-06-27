`timescale 1ns/1ns

module integrator_tb;

    wire [11:0] ALU_output, readOut1, readOut2;
    reg [26:0] instruction;
    reg [2:0] readAddr1,readAddr2,writeAddr;
    reg [11:0] dataIn;
    reg writeEn,clk;

    ALU aloo(instruction, ALU_output);

    RegisterFile reggy(readAddr1, readAddr2, writeAddr, dataIn, writeEn, clk, readOut1, readOut2);

    initial begin 
        clk = 1'b0;
        forever #20 clk = ~clk ;
    end 
    initial begin
        $dumpfile ("integrator.vcd");
        $dumpvars (0,integrator_tb);

        dataIn = 12'b000001100100; //R0 = 100
        writeAddr = 3'b000; 
        writeEn = 1'b1; #50;

        writeEn = 1'b0; #10;
        dataIn = 12'b000000000010; //R1 = 2
        writeAddr = 3'b001; 
        writeEn = 1'b1; #50;

        writeEn = 1'b0; #10;
        dataIn = 12'b010001000000; //R5 = 3.0
        writeAddr = 3'b101; 
        writeEn = 1'b1; #50;

        writeEn = 1'b0; #10;
        dataIn = 12'b010001000000; //R6 = 3.0
        writeAddr=3'b110; 
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b000;
        readAddr2 = 3'b001; #10;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b001; #10;

        dataIn = ALU_output;
        writeAddr = 3'b010;
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b000;
        readAddr2 = 3'b001;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b010; #10;

        dataIn = ALU_output;
        writeAddr = 3'b011;
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b000;
        readAddr2 = 3'b001;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b011; #10;

        dataIn = ALU_output;
        writeAddr = 3'b100;
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b000;
        readAddr2 = 3'b001;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b100; #10;

        dataIn = ALU_output;
        writeAddr = 3'b010;
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b101;
        readAddr2 = 3'b110; #10;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b101; #10;

        dataIn = ALU_output;
        writeAddr = 3'b111;
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b101;
        readAddr2 = 3'b110;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b110; #10;

        dataIn = ALU_output;
        writeAddr = 3'b111;
        writeEn = 1'b1; #50;

        

        writeEn = 1'b0; #10;

        readAddr1 = 3'b000;
        readAddr2 = 3'b001; #10;
        instruction[11:0] = readOut2;
        instruction[23:12] = readOut1;
        instruction[26:24] = 3'b111; #10;

        dataIn = ALU_output;
        writeAddr = 3'b010;
        writeEn = 1'b1; #50;
        
        $finish ;
    end
endmodule