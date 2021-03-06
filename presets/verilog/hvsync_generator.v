`ifndef HVSYNC_GENERATOR_H
`define HVSYNC_GENERATOR_H

module hvsync_generator(
  clk, hsync, vsync, display_on, hpos, vpos);

  input clk;
  output hsync, vsync;
  output reg display_on;
  output reg [8:0] hpos;
  output reg [8:0] vpos;

  // constant declarations for VGA sync parameters
  localparam H_DISPLAY       = 256; // horizontal display area
  localparam H_L_BORDER      =  16; // horizontal left border
  localparam H_R_BORDER      =  16; // horizontal right border
  localparam H_RETRACE       =  16; // horizontal retrace
  localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
  localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
  localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE - 1;

  localparam V_DISPLAY       = 240; // vertical display area
  localparam V_T_BORDER      =   4; // vertical top border
  localparam V_B_BORDER      =  14; // vertical bottom border
  localparam V_RETRACE       =   4; // vertical retrace
  localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
  localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
  localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE - 1;

  wire hmaxxed = (hpos==H_MAX);
  wire vmaxxed = (vpos==V_MAX);

  always @(posedge clk)   
    if(hmaxxed)
      hpos <= 0;
    else
      hpos <= hpos + 1;

  always @(posedge clk)
    if(hmaxxed)
      if (!vmaxxed)
        vpos <= vpos + 1;
      else
        vpos <= 0;

  always @(posedge clk)
  begin
    hsync <= (hpos>=START_H_RETRACE && hpos<=END_H_RETRACE);
    vsync <= (vpos==START_V_RETRACE);
  end

  always @(posedge clk)
  begin
    display_on <= (hpos<H_DISPLAY) && (vpos<V_DISPLAY);
  end

endmodule

`endif
