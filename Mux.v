`timescale 1ns / 10ps

module Mux( 
    input [2:0] sel,               
    output reg [31:0] data
    );        

    wire [31:0] t1,t2,t3,t4,t5;
    
    assign t1 = 5;          //1s = 100e+6 clock cycles
    assign t2 = 6;          //1.5s
    assign t3 = 5;         //1s
    assign t4 = 3;          //0.5s
    assign t5 = 3;         //0.5s

   // This always block gets executed whenever a/b/c/d/sel changes value  
   // When it happens, output is assigned to either a/b/c/d  
   always @ (t1 or t2 or t3 or t4 or t5 or sel) //??????
   begin  
      case (sel)  
         3'b001 : data = t1;  
         3'b010 : data = t2;
         3'b011 : data = t3; 
         3'b100 : data = t4; 
         3'b101 : data = t5; 
         default: data = t1;
      endcase  
   end  
endmodule  