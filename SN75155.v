module SN75155(
input clk, //clock
input reset, // reset 
input transmit, //input to say transmission is ready, can be push button or switch
input [7:0] data, // data transmitted
output reg TxD // transmit data line 
    );
reg TxDready; //register variable to tell when transmission is ready 
reg [3:0] bitcounter; //vector 4 bits counter to count up to 9
reg [13:0] counter; //vector 14 bits counter to count the baud rate, counter = clock / baud rate
reg state, nextstate; // register state variable
reg [9:0] rightshiftreg; // vector data needed to be transmitted 1 start, 8 data & 1 stop bit
reg shift, load, clear; //register variable for shifting, loading the bits and clear the counter

//counter logic
always @ (posedge clk) //positive edge
begin 
    if (reset) begin // reset is asserted (reset = 1)
        state <=0; // state is idle (state = 0)
        counter <=0; // counter for baud rate is reset to 0 
        bitcounter <=0; //counter for bit transmission is reset to 0
    end
    else begin
         counter <= counter + 1; //start counting 
         if (counter >= 10415) //if count to 5207 because we start the conunt from 0, so not 5208
            begin 
            state <= nextstate; //state change to next state
            counter <=0; // reset counter to 0
            if (load) rightshiftreg <= {1'b1,data,1'b0}; //load the data if load is asserted
            if (clear) bitcounter <=0; // reset the bitcounter if clear is asserted
            if (shift) 
                begin // if shift is asserted
                rightshiftreg <= rightshiftreg >> 1; //right shift the data as we transmit the data from lsb
                bitcounter <= bitcounter + 1; //count the bitcounter
                end
            end
          end
end 

//state machine

always @ (state, bitcounter, transmit,rightshiftreg) //trigger by change of state, bitcounter or transmit
begin 
    load <=0; // set load equal to 0 at the beginning
    shift <=0; // set shift equal to 0 at the beginning
    clear <=0; // set clear equal to 0 at the beginning
    TxDready <=1; // set TxDReady equal to 1 so no transmission. When TxD is zero, the receiver knows it is transmitting
    TxD <=0; // set TxD equals to 0 at the beginning to avoid latch
    case (state)
        0: begin // idle state
             if (transmit) begin // assert transmit input
             nextstate <=1; // set nextstate register variable to 1 to transmit state
             load <=1; // set load to 1 to prepare to load the data
             shift <=0; // set shift to 0 so no shift ready yet
             clear <=0; // set clear to 0 to avoid clear any counter
             end else begin // if transmit not asserted
             nextstate <=0; // next state is 0 back to idle
             TxDready <=1; // set TxD to 1 to avoid any transmission
             end
           end
        1: begin  // transmit state
             if (bitcounter >=9) begin // check if transmission is complete or not. If complete
             nextstate <= 0; // set nextstate back to 0 to idle state
             clear <=1; // set clear to 1 to clear all counters
             end else begin // if transmisssion is not complete 
             nextstate <= 1; // set nextstate to 1 to stay in transmit state
             shift <=1; // set shift to 1 to continue shifting the data
             TxD <= rightshiftreg[0]; // shift the bit to output TxD
             end
           end
         default: begin // idle state
                     if (transmit) begin // assert transmit input
                     nextstate <=1; // set nextstate register variable to 1 to transmit state
                     load <=1; // set load to 1 to prepare to load the data
                     shift <=0; // set shift to 0 so no shift ready yet
                     clear <=0; // set clear to 0 to avoid clear any counter
                     end else begin // if transmit not asserted
                     nextstate <=0; // next state is 0 back to idle
                     TxDready <=1; // set TxD to 1 to avoid any transmission
                     end
                  end           
    endcase
end
endmodule