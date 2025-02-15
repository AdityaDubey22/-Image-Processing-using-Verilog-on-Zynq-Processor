`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2024 21:57:12
// Design Name: 
// Module Name: top
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


module top(
input clk,
input rst,
input i_valid,
input [7:0] i_data,
output o_data_ready,
output o_data_valid,
output [7:0] o_data,
input i_data_ready,
output o_intr
    );
    
    wire [71:0] pixel_data;
    wire pixel_data_valid;
    wire axis_prog_Full;
    wire [7:0] conv_data;
    wire conv_data_valid;
    
    assign o_data_ready =!axis_prog_Full;
    
    imagecontrol imgcontrol(
.clk(clk),
.rst(!rst),
.i_data(i_data),
.i_valid(i_valid),
.o_data(pixel_data),
.o_valid(pixel_data_valid),
.o_intr(o_intr)                      
    );
    
    conv conv2(
.clk(clk),
.i_data(pixel_data),
.o_data(conv_data),
.i_valid(pixel_data_valid),
.o_valid(conv_data_valid)
    );
    
    output_buffer  opbuffer(
  .wr_rst_busy(),        // output wire wr_rst_busy
  .rd_rst_busy(),        // output wire rd_rst_busy
  .s_aclk(clk),                  // input wire s_aclk
  .s_aresetn(rst),            // input wire s_aresetn
  .s_axis_tvalid(conv_data_valid),    // input wire s_axis_tvalid
  .s_axis_tready(),    // output wire s_axis_tready
  .s_axis_tdata(conv_data),      // input wire [7 : 0] s_axis_tdata
  .m_axis_tvalid(o_data_valid),    // output wire m_axis_tvalid
  .m_axis_tready(i_data_ready),    // input wire m_axis_tready
  .m_axis_tdata(o_data),      // output wire [7 : 0] m_axis_tdata
  .axis_prog_full(axis_prog_Full)  // output wire axis_prog_full
);
    
endmodule

