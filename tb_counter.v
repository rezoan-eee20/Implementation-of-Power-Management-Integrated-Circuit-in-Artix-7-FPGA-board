
//Testbench for counter:

module tb_counter;
    // Inputs
    reg clk;
    reg reset;
	reg EN;
    reg Up_Down;
    // Outputs
    wire [31:0] count;
	
	parameter half_cycle = 5;
	parameter period1 = 200;
	parameter period2 = 100;

    // Instantiate the Unit Under Test (UUT)
    Up_Down_Counter uut (
        .clk(clk), 
        .reset(reset),
		.EN(EN),
        .Up_Down(Up_Down), 
        .count(count)
    );

//Generate clock with 10 ns clk period.
    initial 
	begin
	clk = 0;
	EN = 0;
	end
	
    always #half_cycle clk = ~clk;
    
    initial begin
        // Apply Inputs
		reset = 1;
		#period1;
        reset = 0;
		#period1;
		
		EN = 1;
        Up_Down = 1;
        #period2;
		EN = 0;
		Up_Down = 1;
		#period2;
		
		EN = 1;
        Up_Down = 0;
        #period2;
		EN = 0;
		Up_Down = 0;
		#period2;
		
		EN = 1;
        Up_Down = 0;
		#period2;
        reset = 1;
        Up_Down = 0;
        #period2;
        reset = 0;  
		
        #period1;
        $finish;              // end of simulation
    end
      
endmodule