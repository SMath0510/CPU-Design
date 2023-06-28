module subtract(D,A,B);

    input [7:0] A,B;
    output [7:0] D;
    wire [7:0] notB, twoB;
    wire carry;

    // Taking the twos complement of the 2nd number
    not n[7:0] (notB[7:0], B[7:0]);
    RCA8 r1(twoB, carry, notB, 8'b00000001, 1'b0);
    
    // Adding the twos complement of the second number and the first number
    RCA8 r2(D, carry, twoB, A, 1'b0);

endmodule

// Adding the twos complement of the second number to the first number using the RCA-8 bit adder

