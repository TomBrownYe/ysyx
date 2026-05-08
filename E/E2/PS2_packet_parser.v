module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done
); 
    reg state, next_state;
    reg [1:0] cnt;
    parameter idle =0,receive =1;
    //counter logic
    always@(posedge clk)begin
        if(reset)
            cnt<=0;
        else if(next_state == receive)begin
            if(cnt ==3)
                cnt<=1;
            else
                cnt<=cnt+1;
        end
        else
            cnt<=0;
    end
    //state logic(combinational)
    always@(*)begin
        case(state)
            idle:next_state = in[3]?receive:idle;
            receive:next_state = (cnt<3)?receive:(in[3]?receive:idle);
            default:next_state = idle;
        endcase
    end
    //state flip flop
    always@(posedge clk)begin
        if(reset)
            state<=idle;
        else
            state<=next_state;
    end
    //output logic
    assign done = (cnt == 3);
endmodule