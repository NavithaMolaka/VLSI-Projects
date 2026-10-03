// UART Transmitter - 8N1 Protocol
// Author: Molaka Navitha - CBIT Proddatur
module uart_tx (
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy,
    output reg tx_done
);
    parameter CLK_FREQ = 50000000;
    parameter BAUD_RATE = 9600;
    parameter BAUD_TICK = CLK_FREQ / BAUD_RATE;
    parameter IDLE=2'b00, START=2'b01, DATA=2'b10, STOP=2'b11;
    reg [1:0] state, next_state;
    reg [12:0] baud_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] data_reg;
    always @(posedge clk or posedge rst) begin
        if(rst) baud_cnt<=0;
        else if(state!=IDLE) begin
            if(baud_cnt==BAUD_TICK-1) baud_cnt<=0;
            else baud_cnt<=baud_cnt+1;
        end else baud_cnt<=0;
    end
    wire baud_tick = (baud_cnt==BAUD_TICK-1);
    always @(posedge clk or posedge rst) begin
        if(rst) state<=IDLE; else state<=next_state;
    end
    always @(*) begin
        next_state=state;
        case(state)
            IDLE: if(tx_start) next_state=START;
            START: if(baud_tick) next_state=DATA;
            DATA: if(baud_tick && bit_cnt==3'd7) next_state=STOP;
            STOP: if(baud_tick) next_state=IDLE;
        endcase
    end
    always @(posedge clk or posedge rst) begin
        if(rst) begin tx<=1; tx_busy<=0; tx_done<=0; bit_cnt<=0; data_reg<=0; end
        else begin
            tx_done<=0;
            case(state)
                IDLE: begin tx<=1; tx_busy<=0; bit_cnt<=0;
                    if(tx_start) begin data_reg<=tx_data; tx_busy<=1; end
                end
                START: begin tx<=0; tx_busy<=1; end
                DATA: begin tx<=data_reg[bit_cnt];
                    if(baud_tick) begin if(bit_cnt==7) bit_cnt<=0; else bit_cnt<=bit_cnt+1; end
                end
                STOP: begin tx<=1; if(baud_tick) begin tx_done<=1; tx_busy<=0; end end
            endcase
        end
    end
endmodule
