`timescale 1ns/10ps

module PMIC_FSM(
	input clk,
	input reset,
	input Low_BAT,
	input Low_POW,
	input ON_OFF,
	input timeOut,
	output reg [2:0] Mux_Sel,
	output reg load,
	output reg en,
	output reg IO_LDO_EN,
	output reg Analog_LDO_EN,
	output reg Logic_LDO_EN,
	output reg Ready 
	);

	reg [3:0] c_state;
	reg [3:0] n_state; 

	parameter IDLE = 4'b0000;	//All inputs and outputs are zero
	parameter ST0 = 4'b1000;    //Pre load state
	parameter ST1 = 4'b0001;	//IO_LDO_ENABLED
	parameter ST2 = 4'b0010;	//Analog_LDO_ENABLED
	parameter ST3 = 4'b0011;	//Logic_LDO_ENABLED, Ready Enabled
	parameter ST4 = 4'b0100;	//ALL LDO & Ready Enabled
	parameter ST5 = 4'b0101;	//Logic_LDO_DISABLED & Ready Disabled
	parameter ST6 = 4'b0110;	//Analog_LDO_DISABLED
	parameter ST7 = 4'b0111;	//IO_LDO_DISABLED 

	
    wire [31:0] data;
    
	//Instantiating counter 
	Timer TMR(clk,reset,data,en,load,timeOut);
	Mux Multiplexer(Mux_Sel,data);
	
	wire ON,OFF;
	
	assign ON = (ON_OFF == 1);
	assign OFF = (ON_OFF == 0);

	always @(posedge clk)
	begin
	if(reset) c_state = IDLE;
	else c_state = n_state;
	end

	always @(posedge clk)
	begin
	en = 0;
	load = 0;
	case(c_state)
	IDLE: begin
		  IO_LDO_EN = 0;
		  Analog_LDO_EN = 0;
		  Logic_LDO_EN = 0;
		  Ready = 0;
		  en = 0;
			if(ON)
		    n_state = ST0;
			else if(OFF)
			n_state = IDLE;
			else 
			n_state = IDLE;
		  end	
	ST0: begin
	       IO_LDO_EN = 0;
           Analog_LDO_EN = 0;
           Logic_LDO_EN = 0;
           Ready = 0;
           if(ON)
           begin
           en = 0;
           Mux_Sel = 3'b001;
           load = 1;
           n_state = ST1;
           end
           else if(OFF)
           n_state = IDLE;
           else 
           n_state = ST0;
	     end	  
	ST1: begin
	       en = 1;
	       load = 0;
			if(ON)
			begin
			IO_LDO_EN = 1;
            Analog_LDO_EN = 0;
            Logic_LDO_EN = 0;
            Ready = 0;
			if(timeOut)
			begin
            en = 0;
            Mux_Sel = 3'b010;
            load = 1;
			n_state = ST2;
			end
			end
			else if(OFF)
			n_state = IDLE;
			else
			n_state = ST1;
		 end 	
	ST2: begin
	       en = 1;
	       load = 0;
		    if(ON)
		    begin
				if(timeOut) 
				begin
				Analog_LDO_EN = 1;
			    IO_LDO_EN = 0;
                Logic_LDO_EN = 0;
                Ready = 0;
				en = 0;
                Mux_Sel = 3'b010;
                load = 1;
				n_state = ST3;
				end
		    end
		    else if(OFF)
			n_state = IDLE;
		    else
			n_state = ST2;
		 end
	ST3: begin
	       en = 1;
	       load = 0;
			if(ON)
			begin
			     if(timeOut) 
                 begin
                 IO_LDO_EN = 0;
                 Analog_LDO_EN = 0;
                 Logic_LDO_EN = 1;
                 Ready = 1;
                 en = 0;
                 Mux_Sel = 3'b011;
                 load = 1;
                 n_state = ST4;
				 end
				 else
                 n_state = ST3;
			end
		    else if(OFF)
			n_state = IDLE;
		    else
			n_state = ST3;
		 end
	ST4: begin
	       en = 0;
	       load = 0;
			if(ON)
			begin
				IO_LDO_EN = 1;				
				Analog_LDO_EN = 1;
				Logic_LDO_EN = 1;
				Ready = 1;
				n_state = ST4;
			end
		    else if(OFF)
			n_state = ST5;
		    else
			n_state = ST4;
		 end	 
	ST5: begin
	       en = 1;
	       load = 0;
			if(ON)
			n_state = IDLE;
		    else if(OFF)
			begin
				if(timeOut) 
				begin
			    IO_LDO_EN = 1;				
                Analog_LDO_EN = 1;
				Logic_LDO_EN = 0;
				Ready = 0;
				en = 0;
                Mux_Sel = 3'b100;
                load = 1;
				n_state = ST6;
			    end
			    else
			    n_state = ST5; 
		    end 
		    else
			n_state = ST5;
		 end
	ST6: begin
	       en = 1;
	       load = 0;
			if(ON)
			n_state = IDLE;
		    else if(OFF)
			begin
				if(timeOut) 
				begin
			    IO_LDO_EN = 1;				
                Analog_LDO_EN = 0;
                Logic_LDO_EN = 0;
                Ready = 0;
                en = 0;
                Mux_Sel = 3'b101;
                load = 1;
				n_state = ST7;
				end
				else 
				n_state = ST6;
			end 	
		    else
			n_state = ST6;
		 end 
	ST7: begin
	       en = 1;
	       load = 0;
			if(ON)
			n_state = IDLE;
		    else if(OFF)
			begin
				if(timeOut)             //t5
				begin
				n_state = IDLE;
				end
				else
				n_state = ST7;
			end 
			else
			 n_state = ST7;
		 end 	 
	default: n_state = IDLE;
	endcase
	end 
	
	// always @(*)		//Output Indications on LED
	// begin
	// case (c_state)
	// IDLE: = ;
	// ST1: = ;
	// ST2: = ;
	// ST3: = ;
	// ST4: = ;
	// ST5: = ;
	// ST6: = ;
	// ST7: = ;
	// default : 
	// endcase
	// end

endmodule 
