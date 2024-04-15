// Code your testbench here
// or browse Examples
module FIFO_synchronous_tb;
  
  reg clk, rst, wr_en, rd_en;
  reg [7:0] buf_in;
  wire [7:0] buf_out;
  wire buf_empty, buf_full;
  wire [7:0] fifo_counter;
  
  // Instantiate the FIFO module
  FIFO_synchronous FS (
    .clk(clk),
    .rst(rst),
    .buf_in(buf_in),
    .buf_out(buf_out),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .buf_empty(buf_empty),
    .buf_full(buf_full),
    .fifo_counter(fifo_counter)
  );
  
  always #5 clk = ~clk;
  
    // input generation
  
  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    buf_in = 0;
    #10; // Reset for a short period
    
    rst = 0;
    #10;
    
    // Write data into the FIFO
    wr_en = 1;
    buf_in = 8'hAA; // Some data example
    #10;
    buf_in = 8'h55;
    #10;
    wr_en = 0;
    #20;
    
    // Read data from the FIFO
    rd_en = 1;
    #20;
    rd_en = 0;
    #20;
    
    // Additional write and read to test further
    wr_en = 1;
    buf_in = 8'hFF;
    #10;
    buf_in = 8'h00;
    #10;
    wr_en = 0;
    rd_en = 1;
    #20;
    rd_en = 0;
    
    // End simulation
    #50;
    $finish;
  end
  
  // Monitoring changes
  initial begin
    $monitor("Time=%t, rst=%b, wr_en=%b, rd_en=%b, buf_in=%h, buf_out=%h, buf_empty=%b, buf_full=%b, fifo_counter=%d",
             $time, rst, wr_en, rd_en, buf_in, buf_out, buf_empty, buf_full, fifo_counter);
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
  
endmodule
    
