module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
); //
     
    // Modify FSM and datapath from Fsm_serialdata
  
    // New: Add parity checking.
     wire odd;
     wire parity_reset;
    assign parity_reset = reset|(state == idle);
    parity inst(clk,parity_reset,in,odd);
      // Use FSM from Fsm_serial
    reg [2:0] state, next_state;
    parameter idle=0,data=1,parity_judge=2,stop_check=3, error_wait=4; 
    integer clk_cnt=0; 
    always @(*) begin
        case(state)
            idle: next_state = (in == 0) ? data : idle;
            data: next_state = (clk_cnt < 8) ? data : parity_judge;
            parity_judge:next_state = stop_check;
            stop_check: next_state = (in == 1) ? idle : error_wait;
            error_wait: next_state = (in == 1) ? idle : error_wait;
            default: next_state = idle;
        endcase
    end
    always @(posedge clk) begin
        if(reset) begin
            state <= idle;
            clk_cnt <= 0;
        end
        else begin
            state <= next_state;
            if(next_state == data)
                clk_cnt <= clk_cnt + 1;
            else
                clk_cnt <= 0;
        end  
        done <= (state == stop_check) & (in == 1)&(odd==1);
    end
    // New: Datapath to latch input bits.
    always@(posedge clk)begin
        if(reset)
            out_byte<=8'd0;
        else begin
            case(state)
                idle:out_byte<=8'd0;
                data:out_byte[clk_cnt-1]<=in;
                stop_check:out_byte<=out_byte;
                error_wait:out_byte<=out_byte;
            endcase
        end
    end
    
endmodule

module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd;

endmodule