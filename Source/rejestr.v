`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2019 23:38:27
// Design Name: 
// Module Name: rejestr
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


module delay#(
    parameter N=1
)
(
    input clk,
    input [N-1:0] in,
    output [N-1:0] out
    );
    reg[N-1:0] val=0;
    
     always @(posedge clk)
     begin
        val<=in;
     end
    assign out=val;
endmodule

module multi_delay #(
    parameter N=1,
    parameter DELAY=5)
    (
     input clk,
     input [N-1:0] in,
     output [N-1:0] out
     );
     wire[N-1:0]  chain[DELAY:0];
     genvar i;
     assign chain[0]= in;
     generate
        if(DELAY<1)
        begin
            assign out=-1;
        end
        if(DELAY==1)
        begin
            assign out=in;
        end
        else
        begin
            for(i=0;i<DELAY;i=i+1)
            begin
                delay#(
                    .N(N))
                del(
                    .clk(clk),
                    .in(chain[i]),
                    .out(chain[i+1])
                    );
            end
            assign out=chain[DELAY];
        end
     endgenerate
endmodule
