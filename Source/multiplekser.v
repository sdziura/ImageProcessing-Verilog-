`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2019 17:40:07
// Design Name: 
// Module Name: multiplekser
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


module multiplekser(
    input [3:0]sw,
    input clk,
    input de_in,
    input h_sync_in,
    input v_sync_in,
    input [23:0] pixel_in,
    output de_out,
    output h_sync_out,
    output v_sync_out,
    output [23:0] pixel_out
    );
 
//Wires
wire [23:0] rgb_mux[7:0];
wire de_mux[7:0];
wire hsync_mux[7:0];
wire vsync_mux[7:0]; 
wire [10:0]xcent;
wire [9:0]ycent; 

reg [23:0]r_pixel_out = 0;
reg r_de = 0;
reg r_vsync = 0;
reg r_hsync = 0;

//Obraz normalny
assign  rgb_mux[0] = pixel_in;
assign de_mux[0] = de_in;
assign hsync_mux[0] = h_sync_in;
assign vsync_mux[0] = v_sync_in;  

//YCbCr
rgb2ycbcr_0 y(
    .clk(clk),
    .RGB(pixel_in),
    .in_v(v_sync_in),
    .in_h(h_sync_in),
    .in_de(de_in),
    .YCbCr(rgb_mux[1]),
    .out_v(vsync_mux[1]),
    .out_h(hsync_mux[1]),
    .out_de(de_mux[1])
    );

//Binaryzacja
localparam Ta = 8'd230;
localparam Tb = 8'd90;
localparam Tc = 8'd200;
localparam Td = 8'd138;
wire [7:0]bin = ( rgb_mux[1][15:8]< Tc && rgb_mux[1][15:8] > Td && rgb_mux[1][7:0] < Ta && rgb_mux[1][7:0] > Tb ) ? 8'd255 : 0;
assign  rgb_mux[2] = {bin, bin, bin};
assign de_mux[2] = de_mux[1];
assign hsync_mux[2] = hsync_mux[1];
assign vsync_mux[2] = vsync_mux[1]; 

//Centroid
centroid_0 centr
(
  .clk(clk),
  .ce(1),
  .rst(0),
  .de(de_mux[2]),
  .vsync(vsync_mux[2]),
  .hsync(hsync_mux[2]),
  .mask(rgb_mux[2]),
  .xcent(xcent),
  .ycent(ycent)
);

vis_centroid_0 vis_centr 
(
  .clk(clk),
  .de(de_mux[2]),
  .vsync(vsync_mux[2]),
  .hsync(hsync_mux[2]),
  .mask(rgb_mux[2]),
  .xcent(xcent),
  .ycent(ycent),
  .pixel_out(rgb_mux[3])
 );

//Sterowanie
always @(posedge clk)
begin
    if (sw == 1)
    begin
        r_pixel_out = rgb_mux[1];
        r_de = de_mux[1];
        r_vsync = vsync_mux[1];
        r_hsync = hsync_mux[1];
     end
    else if (sw == 2)
    begin
        r_pixel_out = rgb_mux[2];
        r_de = de_mux[2];
        r_vsync = vsync_mux[2];
        r_hsync = hsync_mux[2];
     end
    else if (sw == 3)
    begin
        r_pixel_out = rgb_mux[3];
        r_de = de_mux[2];
        r_vsync = vsync_mux[2];
        r_hsync = hsync_mux[2];
     end
    else
    begin
        r_pixel_out = rgb_mux[0];
        r_de = de_mux[0];
        r_vsync = vsync_mux[0];
        r_hsync = hsync_mux[0];
     end
end

//Przypisanie do wyjœæ
assign pixel_out = r_pixel_out;
assign de_out = r_de;
assign h_sync_out = r_hsync;
assign v_sync_out = r_vsync;

endmodule
