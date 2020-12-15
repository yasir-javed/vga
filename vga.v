`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:07:06 04/13/2010 
// Design Name: 
// Module Name:    counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga(
	input clk,
	input 	reset,
	
	output reg [2:0] red,
	output reg [2:0] green,
	output reg [1:0] blue,
	output reg	 hsync,
	output reg	 vsync,
	input	[7:0] sw
	
    );

parameter hpixels = 12'd800;
parameter vlines = 12'd521;
parameter hbp = 12'd144;
parameter hfp = 12'd784;
parameter vbp = 12'd31;
parameter vfp = 12'd511;
parameter W = 256;
parameter H = 256;
wire [10:0] C1, R1;

reg [11:0] hc_new;
reg [9:0] hc;
reg [9:0] vc;
reg vidon;
reg spriteon;
reg vsenable;

always @ (posedge clk)
	if (reset || vsenable)	hc_new <= 0;
	else					hc_new <= hc_new + 1;

always@* hc = hc_new[11:2];
			
always@* vsenable = hc == hpixels - 1;
	
always @* hsync = hc > (127);

always @ (posedge clk)
	if (reset || vc_clr)	vc <= 0;
	else if (vsenable)		vc <= vc + 1;

assign vc_clr = vsenable & (vc == vlines - 1);

always@* vsync = vc > 2;

always @(*) vidon = ((hc < hfp) && (hc > hbp) && (vc < vfp) && (vc > vbp));



assign C1 = 11'd100;
assign R1 = 11'd100;


always @(*) spriteon = ((hc >= C1 + hbp) && (hc < C1 + hbp + W) && (vc >= R1 + vbp) && (vc < R1 + vbp + H));

always @(*)
	begin
		red = 0;
		green = 0;
		blue = 0;
		if ((spriteon == 1) && (vidon == 1))
			begin
				red 	= sw[2:0];
				green 	= sw[5:3];
				blue	= sw[7:6];
			end
	end
	
	
endmodule
