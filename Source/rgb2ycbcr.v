`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2019 15:56:27
// Design Name: 
// Module Name: rgb2ycbcr
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


module rgb2ycbcr(
    input clk,
    input [23:0] RGB,
    input in_v,
    input in_h,
    input in_de,
    output [23:0] YCbCr,
    output out_v,
    output out_h,
    output out_de
    );
    
    //Input pixel
    wire signed [17:0]R ;
    wire signed [17:0]G ;
    wire signed [17:0]B ;
    
    //input sync
    wire signed [2:0]in_sync;
    
    //After factorising
    wire signed [35:0]RY ;
    wire signed [35:0]GY ;
    wire signed [35:0]BY ;
    wire signed [35:0]RCb ;
    wire signed [35:0]GCb ;
    wire signed [35:0]BCb ;
    wire signed [35:0]RCr ;
    wire signed [35:0]GCr ;
    wire signed [35:0]BCr ;
    
    //Output pixel
    wire signed [8:0]Y ;
    wire signed [8:0]Cb ;
    wire signed [8:0]Cr ;
    
    //output sync
    wire signed [2:0]out_sync;
    
    //Input pixel
    assign R = {10'b0,RGB[23:16]};
    assign B = {10'b0,RGB[15:8]};
    assign G = {10'b0,RGB[7:0]};
    
    //Output pixel
    assign YCbCr = {Y[7:0],Cr[7:0],Cb[7:0]};
    
    //In/Out sync
    assign in_sync = {in_v, in_h, in_de};
    assign out_v = out_sync[2];
    assign out_h = out_sync[1];
    assign out_de = out_sync[0];
    
    //Factorising
    mult_gen_0 R_Y (.CLK(clk),.A(R),.B(18'b000000000010011001),.P(RY)); //0.299 * R
    mult_gen_0 G_Y (.CLK(clk),.A(G),.B(18'b000000000100101101),.P(GY)); //0.587 * G
    mult_gen_0 B_Y (.CLK(clk),.A(B),.B(18'b000000000000111010),.P(BY)); //0.114 * B
    
    mult_gen_0 R_Cb (.CLK(clk),.A(R),.B(18'b111111111110101010),.P(RCb)); //-0.168736 * R
    mult_gen_0 G_Cb (.CLK(clk),.A(G),.B(18'b111111111101010110),.P(GCb)); //-0.331264 * G
    mult_gen_0 B_Cb (.CLK(clk),.A(B),.B(18'b000000000100000000),.P(BCb)); //0.5 * B
    
    mult_gen_0 R_Cr (.CLK(clk),.A(R),.B(18'b000000000100000000),.P(RCr)); //0.5 * R
    mult_gen_0 G_Cr (.CLK(clk),.A(G),.B(18'b111111111100101010),.P(GCr)); //-0.418688 * G
    mult_gen_0 B_Cr (.CLK(clk),.A(B),.B(18'b111111111111010110),.P(BCr)); //-0.081312 * B
    
    //Summing
    sum Ysum (.clk(clk), .R(RY), .G(GY), .B(BY), .C(9'b0), .result(Y));
    sum Cbsum (.clk(clk), .R(RCb), .G(GCb), .B(BCb), .C(9'b010000000), .result(Cb));
    sum Crsum (.clk(clk), .R(RCr), .G(GCr), .B(BCr), .C(9'b010000000), .result(Cr));
    
    //Latency
    multi_delay #(.N(3), .DELAY(5)) sync_late (.clk(clk), .in(in_sync), .out(out_sync));
    
endmodule
