module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output reg [23:0] out_bytes,
    output done); //

    // FSM from fsm_ps2
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
    // New: Datapath to store incoming bytes.
    always@(posedge clk)begin
        if(reset)
            out_bytes<=24'd0;
        else if((state == idle)|(cnt==3))
            out_bytes[23:16]<=in;
        else if(cnt==2)
            out_bytes[7:0]<=in;
        else if(cnt==1)
            out_bytes[15:8]<=in;
        else
            out_bytes<=24'd0;
    end
endmodule
