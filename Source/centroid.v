`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2019 18:48:26
// Design Name: 
// Module Name: centroid
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module centroid
#(
    parameter IMG_H = 720,
    parameter IMG_W = 1280
)
(
    input clk,
    input ce,
    input rst,
    input de,
    input vsync,
    input hsync,
    input [23:0] mask,
    output [10:0] xcent,
    output [9:0] ycent
);
 
 
//Aktualne pozycje pixela 
reg [10:0] x_pos = 0;
reg [9:0] y_pos = 0;

//Pomocnicze
reg prev_vsync = 0;
wire eof;
wire qv;
wire qw;

//Liczniki
reg [19:0] m = 0;
reg [31:0] m_x = 0;
reg [31:0] m_y = 0;

//Wspó³rzêdne œrodka
wire [31:0] x_srodw;
wire [31:0] y_srodw; 
reg [10:0] x_srod = 0;
reg [9:0] y_srod = 0;

//Przechodzenie po pixelach
always @(posedge clk)
begin
    if(vsync)
    begin
        x_pos <= 0;
        y_pos <= 0;
    end
    else
        if(de)
        begin
            x_pos <= x_pos + 1;
            if(x_pos == IMG_W-1)
            begin
                x_pos <= 0;
                y_pos <= y_pos + 1;
                if(y_pos == IMG_H-1) y_pos <= 0;
            end
        end

//Akumulacja
    if(mask) 
    begin
        m_x <= m_x + x_pos;
        m_y <= m_y + y_pos;
        m <= m + 1;
    end
    
    //Reset
    if(eof)
    begin
        m_x <= 0;
        m_y <= 0;
        m <= 0;
    end
    
    //Przepisanie wyniku dzielenia
    if(eof)
    begin
        x_srod = x_srodw[10:0];
        y_srod = y_srodw[9:0];
    end
    
//Zapamiêtywanie sygna³u
prev_vsync <= vsync;
end

//End of Frame assign
assign eof=(prev_vsync==1'b0 & vsync==1'b1) ? 1'b1 : 1'b0;

//Dzielenie
divider_32_20_0 mx (.clk(clk), .start(eof), .dividend(m_x), .divisor(m), .quotient(x_srodw), .qv(qv));
divider_32_20_0 my (.clk(clk), .start(eof), .dividend(m_y), .divisor(m), .quotient(y_srodw), .qv(qw));

//Wynik assign
assign xcent = x_srod;
assign ycent = y_srod;

endmodule
