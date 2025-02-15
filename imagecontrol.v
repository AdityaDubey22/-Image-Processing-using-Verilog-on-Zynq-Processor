`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2024 01:46:03
// Design Name: 
// Module Name: imagecontrol
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


module imagecontrol(
input clk,
input rst,
input [7:0] i_data,
input i_valid,
output reg [71:0] o_data,
output o_valid,
output reg o_intr 
    );
    
    reg [8:0] pixel_counter;
    reg [1:0] currentwrlinebuffer; 
    reg [3:0] linebufferdatavalid;
    reg [3:0] linebuffer_rdvalid;    
    reg [1:0] currentrdlinebuffer;
    wire [23:0] odata0;
    wire [23:0] odata1;
    wire [23:0] odata2;
    wire [23:0] odata3;
    reg [8:0] rdcounterlinebuffer;
    reg rd_linebuffer;
    reg [11:0] totalpixelcounter;
    reg rd_state;

    
    localparam IDLE = 'b0,
               RD_BUFFER = 'b1;
    
    assign o_valid = rd_linebuffer;
    
    always@(posedge clk )
    begin
        if(rst)
        totalpixelcounter <= 0;
        else
        begin
            if(i_valid & !rd_linebuffer)
            totalpixelcounter <= totalpixelcounter + 1 ;
            else if (!i_valid & rd_linebuffer)
            totalpixelcounter <= totalpixelcounter - 1 ;
        end
    end
    
    always@(posedge clk)
    begin
        if(rst)
        begin
        rd_state <= IDLE;
        rd_linebuffer <= 1'b0;
        o_intr <= 1'b0;                     
        end
        else
        begin
            case(rd_state)
               IDLE : begin
                    o_intr = 1'b0;                     
                    if(totalpixelcounter>=1536)
                    begin
                        rd_linebuffer <= 1'b1;
                        rd_state <= RD_BUFFER;
                    end
                end
                RD_BUFFER :begin
                    if(rdcounterlinebuffer == 511)
                    begin
                        rd_state <= IDLE;
                        rd_linebuffer <= 1'b0; 
                        o_intr <= 1'b1;                     
                    end                
                end
            endcase    
        end    
    end
    
    always@(posedge clk)
    begin
    if(rst)
    pixel_counter = 0;
    else
        begin
            if(i_valid)
            pixel_counter <= pixel_counter +1 ;
        end
    end
    
    always@(posedge clk)
    begin
    if(rst)
    currentwrlinebuffer = 0;
    else
        begin
            if(pixel_counter == 511 & i_valid)
            currentwrlinebuffer <= currentwrlinebuffer+1;
        end
    end
    
    always@(*)
    begin
     linebufferdatavalid = 4'h0;
     linebufferdatavalid[currentwrlinebuffer] = i_valid;
    end
    
    always@(*)
    begin
    case(currentrdlinebuffer)
    0:begin
    o_data = {odata2,odata1,odata0};
    end
    1:begin
    o_data = {odata3,odata2,odata1};
    end
    2:begin
    o_data = {odata0,odata3,odata2};
    end
    3:begin
    o_data = {odata1,odata2,odata3};
    end
    
    endcase
    end
   
    always@(posedge clk)
    begin
    if(rst)
    rdcounterlinebuffer = 0;
    else
    if(rd_linebuffer)
    rdcounterlinebuffer <= rdcounterlinebuffer+1;
    end
    
    always@(posedge clk)
    begin
        if(rst)
        currentrdlinebuffer <= 0;
        else
            begin
                if(rdcounterlinebuffer == 511 & rd_linebuffer)
                currentrdlinebuffer <= currentrdlinebuffer + 1 ;
            end
    end
    
    always@(*)
            begin
    case(currentrdlinebuffer)
        0:begin
            linebuffer_rdvalid[0] = rd_linebuffer;
            linebuffer_rdvalid[1] = rd_linebuffer;
            linebuffer_rdvalid[2] = rd_linebuffer;
            linebuffer_rdvalid[3] = 1'b0;
        end
       1:begin
            linebuffer_rdvalid[0] = 1'b0;
            linebuffer_rdvalid[1] = rd_linebuffer;
            linebuffer_rdvalid[2] = rd_linebuffer;
            linebuffer_rdvalid[3] = rd_linebuffer;
        end
       2:begin
             linebuffer_rdvalid[0] = rd_linebuffer;
             linebuffer_rdvalid[1] = 1'b0;
             linebuffer_rdvalid[2] = rd_linebuffer;
             linebuffer_rdvalid[3] = rd_linebuffer;
       end  
      3:begin
             linebuffer_rdvalid[0] = rd_linebuffer;
             linebuffer_rdvalid[1] = rd_linebuffer;
             linebuffer_rdvalid[2] = 1'b0;
             linebuffer_rdvalid[3] = rd_linebuffer;
       end        
    endcase
    end
 
    
    
    line_buffer l0(
.clk(clk),
.rst(rst),
.i_data(i_data),
.o_data(odata0),
.data_valid(linebufferdatavalid[0]),
.rd_valid(linebuffer_rdvalid[0])
    );
    
    line_buffer l1(
.clk(clk),
.rst(rst),
.i_data(i_data),
.o_data(odata1),
.data_valid(linebufferdatavalid[1]),
.rd_valid(linebuffer_rdvalid[1])
    );
    
    line_buffer l2(
.clk(clk),
.rst(rst),
.i_data(i_data),
.o_data(odata2),
.data_valid(linebufferdatavalid[2]),
.rd_valid(linebuffer_rdvalid[2])
    );
    
    line_buffer l3(
.clk(clk),
.rst(rst),
.i_data(i_data),
.o_data(odata3),
.data_valid(linebufferdatavalid[3]),
.rd_valid(linebuffer_rdvalid[3])
    );
    
    
    
endmodule
