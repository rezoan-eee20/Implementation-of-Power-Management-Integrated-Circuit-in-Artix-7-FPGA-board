`timescale 1ns / 10ps


module Test_Bench_PMIC;

	reg clk,reset,Low_BAT,Low_POW,ON_OFF,timeOut;    // declare all inputs as register
	wire Mux_Sel,load,en,IO_LDO_EN,Analog_LDO_EN,Logic_LDO_EN,Ready;

    parameter half_cycle = 5;   // Clock period = 10ns
	
	// instantiate the verilog code 
    PMIC_FSM UUT (clk,reset,Low_BAT,Low_POW,ON_OFF,timeOut,Mux_Sel,load,en,IO_LDO_EN,Analog_LDO_EN,Logic_LDO_EN,Ready);
	
	initial                    // Initializing all inputs
	   begin
	       clk = 1'b0;
	       Low_BAT = 1'b0;
	       Low_POW = 1'b0;
	       ON_OFF = 1'b0;
	       timeOut = 1'b0;
	   end
	
	always 
	   #half_cycle clk = !clk;  // clock generator

	initial
	   begin
        reset = 1'b1;       // reset
        #100;               // wait for 100ns
        reset = 1'b0;
        #100;
        
        ON_OFF = 1'b1;
        #500;
        ON_OFF = 1'b0;
        #100;
        
        reset = 1'b1;       // reset
        #200;
        $finish;              // end of simulation
	   end
endmodule