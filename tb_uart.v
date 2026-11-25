`timescale 1ns/1ps
module tb_uart;
    reg clk=0,rst=1,start=0;
    reg [7:0] data_in=8'hA5;
    wire tx,busy,done;
    wire [7:0] data_out;
    wire valid;
    always #5 clk=~clk;
    uart_tx #(.CLKS_PER_BIT(8)) tx0(.clk(clk),.rst(rst),.start(start),.data_in(data_in),.tx(tx),.busy(busy),.done(done));
    uart_rx #(.CLKS_PER_BIT(8)) rx0(.clk(clk),.rst(rst),.rx(tx),.data_out(data_out),.valid(valid));
    initial begin
        #22 rst=0; @(negedge clk); start=1; @(negedge clk); start=0;
        wait(valid); #1;
        if(data_out!==data_in) $fatal(1,"UART mismatch: got %h expected %h",data_out,data_in);
        $display("PASS: UART loopback received %h",data_out);
        wait(done); #10; $finish;
    end
endmodule
