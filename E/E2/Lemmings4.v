module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging ); 
reg [2:0]state,next_state;
    parameter wl=0,wr=1,fl=2,fr=3,dl=4,dr=5,die=6;
    integer clk_cnt;
    initial begin
        clk_cnt = 0; 
    end
    always@(*)begin
        case(state)
            wl:next_state = ground?(dig?dl:(bump_left?wr:wl)):fl;
            wr:next_state = ground?(dig?dr:(bump_right?wl:wr)):fr;
            fl:next_state = ground?((clk_cnt>20)?die:wl):fl;
            fr:next_state = ground?((clk_cnt>20)?die:wr):fr;
            dl:next_state = ground?dl:fl;
            dr:next_state = ground?dr:fr;
            die:next_state = die;
            default:next_state = 3'dx;
        endcase
    end
    always@(posedge clk,posedge areset)begin
        if(areset)begin
            state<=wl;
           clk_cnt<=0; 
        end
        else begin
            state<=next_state;
                if((next_state ==fl)|(next_state == fr))
                clk_cnt<=clk_cnt+1;
                else
                clk_cnt<=0;
    end
    end
    always@(*)begin
        case(state)
            wl:{walk_left,walk_right,aaah,digging} = 4'b1000;
            wr:{walk_left,walk_right,aaah,digging} = 4'b0100;
            fl:{walk_left,walk_right,aaah,digging} = 4'b0010;
            fr:{walk_left,walk_right,aaah,digging} = 4'b0010;
            dl:{walk_left,walk_right,aaah,digging} = 4'b0001;
            dr:{walk_left,walk_right,aaah,digging} = 4'b0001;
            die:{walk_left,walk_right,aaah,digging} = 4'b0000;
            default:{walk_left,walk_right,aaah,digging} = 4'dx;
        endcase
    end
endmodule
