`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2019 19:13:54
// Design Name: 
// Module Name: tb_rgb2ycbcr
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

module stimulate(
    
    output clk,
    output [23:0] rgb,
    output v,
    output h,
    output de
);

reg clkk = 1'b0;
reg [7:0]r_r = 8'b01110011;
reg [7:0]r_g = 8'b11001000;
reg [7:0]r_b = 8'b01000001;

reg r_h = 1'b1;
reg r_v = 1'b1;
reg r_de = 1'b1;
initial
begin
    while(1)
    begin
        #1; clkk=1'b0;
        #1; clkk=1'b1;
    end
end

assign clk = clkk;
assign rgb = {r_r, r_g, r_b};
assign v = r_v;
assign h = r_h;
assign de = r_de;

endmodule


module tb_rgb2ycbcr(

    );

wire de;
wire h;
wire v;
wire clk;
wire [23:0]pix;
    
stimulate stim(.clk(clk), .rgb(pix), .h(h), .de(de), .v(v));

rgb2ycbcr rrr (.clk(clk), .RGB(pix), .in_v(v), .in_h(h), .in_de(de));

endmodule
