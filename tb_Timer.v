`timescale 1ns / 10ps

module Test_Bench_Timer;

	reg clk,reset,data,en,load;    // declare all inputs as register
//	reg t1,t2,t3,t4,t5,sel;
	wire timeOut;			       // declare all outputs as wire

    parameter half_cycle = 5;   // Clock period = 10ns
	
	
	// instantiate the verilog code 
	Timer UUT(clk,reset,data,en,load,timeOut);
//	Mux UUT2 (t1,t2,t3,t4,t5,sel,data);

	
	initial                    // Initializing all inputs
	   begin
	       clk = 1'b0;
	       en = 1'b0;
	       load = 1'b0;
	   end
	
	always 
	   #half_cycle clk = !clk;  // clock generator

	initial
	   begin
        reset = 1'b1;       // reset   
        #100;      
        reset = 1'b0;
        #100;
//        sel = 3'b001;       //t1
//        #10;

		load = 1'b1;
        #100;               // wait for 100ns
        load = 1'b0;
        #100;

        en = 1'b1;
        #100;
        en = 1'b0;
        #100;
        
        reset = 1'b1;       // reset   
        #100;      
        reset = 1'b0;
        #100;
//        sel = 3'b001;       //t1
//        #10;
        en = 1'b1;
        #100;
        en = 1'b0;
        #100;

        load = 1'b1;
        #100;               // wait for 100ns
        load = 1'b0;
        #100;

        en = 1'b1;
        #100;
        en = 1'b0;
        #100;
        
        
        reset = 1'b1;       // reset
        #200;
        $finish;              // end of simulation
	   end
endmodule