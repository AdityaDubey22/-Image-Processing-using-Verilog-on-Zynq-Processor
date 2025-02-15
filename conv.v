`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2024 20:15:56
// Design Name: 
// Module Name: conv
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


module conv(
input clk,
input [71:0] i_data,
output reg [7:0] o_data,
input i_valid,
output reg o_valid
    );
    integer i;
    reg [7:0] kernel [8:0];
    reg [15:0]multdata [8:0];
    reg mult_valid;
    reg [15:0] sum_data;
    reg [15:0] sum_dataInt;
    reg sum_valid;
    reg conv_valid;
    
    initial
    begin
    for(i=0;i<9;i=i+1)
        begin
            kernel[i] = 1;
        end
    end
    
    always@(posedge clk)
    begin
        for (i=0;i<9;i=i+1)
        begin
            multdata[i] <= kernel[i]*i_data[i*8+:8];        
        end
        mult_valid <= i_valid;
    end
    
    always@(*)
    begin
        sum_dataInt = 0;
        for(i=0;i<9;i=i+1)
        begin
            sum_dataInt = sum_dataInt + multdata[i];
        end
    end
    
    always@(posedge clk)
    begin
    sum_data <= sum_dataInt;
    sum_valid <= mult_valid;
    end
    
    always@(posedge clk)
    begin 
        o_data <= sum_data/9;
        o_valid <= sum_valid; 
    end
    
endmodule
