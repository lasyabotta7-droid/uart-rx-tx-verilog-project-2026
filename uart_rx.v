module uart_rx #(parameter integer CLKS_PER_BIT=16)(
    input wire clk, rst, rx,
    output reg [7:0] data_out,
    output reg valid
);
    localparam IDLE=2'd0, START=2'd1, DATA=2'd2, STOP=2'd3;
    reg [1:0] state;
    integer count;
    reg [2:0] bit_index;
    reg [7:0] data;
    always @(posedge clk or posedge rst) begin
        if(rst) begin state<=IDLE; count<=0; bit_index<=0; data<=0; data_out<=0; valid<=0; end
        else begin
            valid<=0;
            case(state)
                IDLE: if(!rx) begin state<=START; count<=0; end
                START: if(count==(CLKS_PER_BIT/2)-1) begin
                    if(!rx) begin count<=0; bit_index<=0; state<=DATA; end
                    else state<=IDLE;
                end else count<=count+1;
                DATA: if(count==CLKS_PER_BIT-1) begin
                    count<=0; data[bit_index]<=rx;
                    if(bit_index==7) state<=STOP;
                    else bit_index<=bit_index+1;
                end else count<=count+1;
                STOP: if(count==CLKS_PER_BIT-1) begin
                    data_out<=data; valid<=1; state<=IDLE; count<=0;
                end else count<=count+1;
                default: state<=IDLE;
            endcase
        end
    end
endmodule
