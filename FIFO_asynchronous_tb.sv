// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module FIFO_asynchronous_tb;

  // Inputs
  reg clk_r;
  reg clk_w;
  reg rst;
  reg [7:0] buf_in;
  reg wr_en;
  reg rd_en;

  // Outputs
  wire [7:0] buf_out;
  wire buf_empty;
  wire buf_full;
  wire [7:0] fifo_counter;

  // Instantiate the FIFO Module
  FIFO_asynchronous uut (
    .clk_r(clk_r), 
    .clk_w(clk_w), 
    .rst(rst), 
    .buf_in(buf_in), 
    .buf_out(buf_out), 
    .wr_en(wr_en), 
    .rd_en(rd_en), 
    .buf_empty(buf_empty), 
    .buf_full(buf_full), 
    .fifo_counter(fifo_counter)
  );

  // Clock processes for read and write clocks
  always #10 clk_r = ~clk_r; // 50 MHz read clock
  always #15 clk_w = ~clk_w; // 33.33 MHz write clock

  initial begin
    // Initialize Inputs
    clk_r = 0;
    clk_w = 0;
    rst = 1;
    buf_in = 0;
    wr_en = 0;
    rd_en = 0;

    // Reset the FIFO
    #100;
    rst = 0;
    #30;

    // Write data to FIFO
    buf_in = 8'hAA; wr_en = 1; // Input data
    #30; wr_en = 0;
    #30; buf_in = 8'hBB; wr_en = 1;
    #30; wr_en = 0;
    #30; buf_in = 8'hCC; wr_en = 1;
    #30; wr_en = 0;

    // Read data from FIFO
    #50; rd_en = 1;
    #30; rd_en = 0;
    #30; rd_en = 1;
    #30; rd_en = 0;
    #30; rd_en = 1;
    #30; rd_en = 0;

    // Finish simulation
    #100;
    $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %t, buf_in = %h, buf_out = %h, wr_en = %b, rd_en = %b, buf_empty = %b, buf_full = %b, fifo_counter = %h",
             $time, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter);
    
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule

