module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
); 
    reg [1:0] state, next_state;
    parameter idle=0,data=1, stop_check=2, error_wait=3; 
   integer clk_cnt=0; 
    always @(*) begin
        case(state)
            idle: next_state = (in == 0) ? data : idle;
            data: next_state = (clk_cnt < 8) ? data : stop_check;
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
        done <= (state == stop_check) & (in == 1);
    end
endmodule