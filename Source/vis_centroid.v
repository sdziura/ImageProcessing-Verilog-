`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2019 15:50:15
// Design Name: 
// Module Name: vis_centroid
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


module vis_centroid
#(
    parameter IMG_H = 720,
    parameter IMG_W = 1280
)
(
    input clk,
    input de,
    input vsync,
    input hsync,
    input [23:0] mask,
    input [10:0] xcent,
    input [9:0] ycent,
    output [23:0] pixel_out
    );

//Aktualne pozycje pixela 
reg [10:0] x_pos = 0;
reg [9:0] y_pos = 0;

//Pomocnicze
reg prev_vsync = 0;
wire eof;

//Liczniki
reg [19:0] m = 0;
reg [31:0] m_x = 0;
reg [31:0] m_y = 0;

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
end

assign pixel_out=((x_pos[10:0]==xcent || y_pos[9:0]==ycent)?8'hff:mask);

endmodule
