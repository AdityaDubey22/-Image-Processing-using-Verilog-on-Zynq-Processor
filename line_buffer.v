`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2024 19:45:17
// Design Name: 
// Module Name: line_buffer
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


module line_buffer(
input clk,
input rst,
input [7:0] i_data,
output [23:0] o_data,
input data_valid,
input rd_valid
    );

reg [7:0] line [511:0];    
reg [8:0] wr_pntr; 
reg [8:0] rd_pntr; 
    
always@(posedge clk)
    begin
        if(rst)
        wr_pntr <= 'd0;
        else if(data_valid)
        wr_pntr <= wr_pntr + 'd1 ; 
    end

always@(posedge clk)
    begin
        if(data_valid)
        line[wr_pntr] <= i_data;    
    end

assign o_data = {line[rd_pntr],line[rd_pntr+1],line[rd_pntr+2]};

always@(posedge clk)
    begin 
        if(rst)
        rd_pntr <= 'd0;
        else if (rd_valid)
        rd_pntr <= rd_pntr + 'd1 ;
    end

endmodule
