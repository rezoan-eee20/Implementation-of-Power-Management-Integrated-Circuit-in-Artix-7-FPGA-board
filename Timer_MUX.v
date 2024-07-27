`timescale 1ns / 10ps

module Timer_Mux(
	input clk,
	input reset,
	input en,
	input load, 
    input [2:0] Mux_Sel,               
	output timeOut
    );        
    
	wire [31:0] data;
	
	Timer TMR(clk,reset,data,en,load,timeOut);
	Mux Multiplexer(Mux_Sel,data);

endmodule  