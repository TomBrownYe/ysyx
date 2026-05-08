module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah ); 
    reg[1:0] state,next_state;
    parameter wl=0,wr=1,fl=2,fr=3;
    always@(*)begin
        case(state)
            wl:next_state = ground?(!bump_left?wl:wr):fl;
            wr:next_state = ground?(!bump_right?wr:wl):fr;
            fl:next_state = ground?wl:fl;
            fr:next_state = ground?wr:fr;
            default:next_state = 1'dx;
        endcase
    end
    always@(posedge clk or posedge areset)begin
        if(areset)
            state<=wl;
        else
            state<=next_state;
    end
    always@(*)begin
        case(state)
            wl:{aaah,walk_left,walk_right}=3'b010;
            wr:{aaah,walk_left,walk_right}=3'b001;
            fl:{aaah,walk_left,walk_right}=3'b100;
            fr:{aaah,walk_left,walk_right}=3'b100;
            default:{aaah,walk_left,walk_right}=3'dx;
        endcase
    end
endmodule
