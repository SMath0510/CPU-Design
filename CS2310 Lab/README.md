This is the code for the Verilog Final Assignment.

The way to run this code is to open the terminal in the desired folder where we have stored the verilog files.

In the command prompt/ shell / terminal we type in the command that helps us to compile all the files and generate the a.out file

Command 1:
iverilog HalfAdder.v FullAdder.v RCA8.v NOT.v OR.v Subtract.v Add.v AND.v Decrement.v Increment.v Decoder.v CPU.v TestBench.v

The other command helps us in running the a.out file and generates the outputs based on the instructions given

Command 2:
vvp a.out

The final command helps us in plotting our results in a graph and this gives a visual repesentation of our program by plotting it in the graph

Command 3: 
gtkwave CPU.vcd

