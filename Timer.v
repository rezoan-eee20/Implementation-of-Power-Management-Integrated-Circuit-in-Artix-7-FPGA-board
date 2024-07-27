`timescale 1ns / 10ps

module Timer(
    input clk,
    input reset,
    input wire [31:0] data,
    input en,
    input load,
    output reg timeOut
    );
    
    reg [31:0] count;
    reg [31:0] timeval;
    
    always @(posedge clk) 
    begin
      timeOut = 0;
      if (reset)
      begin
      count = timeval;  
      end
      
      else if (load)
      begin
      timeval = data; 
      count = timeval;
      end
      
      else if (en)
      begin    
        if (count == 0)
        timeOut = 1;
        else
        count = count-1;
      end
    end
endmodule
