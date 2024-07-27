`timescale 1ns / 10ps

module Down_Counter(
    input clk,
    input reset,
    input en,
    output wire [31:0] count_value,
    output reg [31:0] count 
    );
    
    assign count_value = 32'd15;
    
    always @(posedge clk or posedge reset) 
	begin
      if (reset) count = count_value;
      else 
	  begin
         if (count==0) count = count_value;
          else
          begin
            if (en) count=count-1;
			else count=count;
		  end	
      end     
    end
endmodule