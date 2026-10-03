`timescale 1ns/1ps
module uart_tx_tb;
    reg clk, rst, tx_start;
    reg [7:0] tx_data;
    wire tx, tx_busy, tx_done;

    uart_tx #(.CLK_FREQ(500), .BAUD_RATE(50)) dut (
        .clk(clk), .rst(rst), .tx_start(tx_start), 
        .tx_data(tx_data), .tx(tx), 
        .tx_busy(tx_busy), .tx_done(tx_done)
    );

    initial begin 
        clk=0; 
        forever #10 clk=~clk; 
    end

    initial begin
        $dumpfile("uart_tx.vcd"); 
        $dumpvars(0, uart_tx_tb);
        rst=1; tx_start=0; tx_data=0; 
        #100; rst=0; #50;
        
        tx_data=8'hA5; tx_start=1; 
        #20; tx_start=0; 
        wait(tx_done); #100;
        
        tx_data=8'h55; tx_start=1; 
        #20; tx_start=0; 
        wait(tx_done); #100;
        
        $display("Simulation Done");
        $finish;
    end
endmodule
