`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2019 17:41:50
// Design Name: 
// Module Name: sum
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


module sum(
    input clk,
    input [35:0] R,
    input [35:0] G,
    input [35:0] B,
    input [8:0] C,
    output [8:0] result
    );
    
    wire [8:0] Re;
    wire [8:0] Ge;
    wire [8:0] Be;
    wire [8:0] Ce;
    
    wire [8:0] RGe;
    wire [8:0] BCe;
    
    wire [8:0] RGBCe;
    
    assign Re = {R[35],R[17:9]};
    assign Ge = {G[35],G[17:9]};
    assign Be = {B[35],B[17:9]};
    assign Ce = C;
    assign result = RGBCe;
    
    c_addsub_0 RG (.CLK(clk), .A(Re), .B(Ge), .S(RGe) );
    c_addsub_0 CB (.CLK(clk), .A(Be), .B(Ce), .S(BCe) );
    
    c_addsub_0 RGCB (.CLK(clk), .A(RGe), .B(BCe), .S(RGBCe) );
    
    
endmodule
