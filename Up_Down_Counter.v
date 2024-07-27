//32 bit UP/DOWN counter:

//Verilog module for UpDown counter
//When Up mode is selected, counter counts from 0 to 15 and then again from 0 to 15.
//When Down mode is selected, counter counts from 15 to 0 and then again from 15 to 0.
//Changing mode doesn't reset the count value to zero.
//You have apply high value to reset, to reset the counter output.

module Up_Down_Counter(
    clk,
    reset,
	EN,
    Up_Down,  //high for UP counter and low for Down counter
    count
    );

    
    //input ports and their sizes
    input clk,reset,EN,Up_Down;
    //output ports and their size
    output [31:0] count; //4-bit counter 
    //Internal variables
    reg [31:0] count = 0;  
	integer count_value = 15
    
    always @((posedge(clk) and EN) or posedge(reset))
    begin
        if(reset == 1) count <= 0;
		
        else  
		begin		
            if(Up_Down == 1)  	//Up mode selected (Up_Down == 1)
			begin 
                if(count == count_value) count <= 0;
                else count <= count + 1; 	//Increment counter
			end 
				
            else 				//Down mode selected (Up_Down == 0)
			begin 
				if(count == 0)	count <= count_value;		
				else count <= count - 1; 	//Decrement counter
			end 
		end 	
    end    
endmodule