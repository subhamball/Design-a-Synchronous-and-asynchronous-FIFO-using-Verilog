// Code your design here
module FIFO_synchronous(clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter);
  
  input clk, rst, wr_en, rd_en;
  input [7:0] buf_in; //data in
  output reg [7:0] buf_out; //data out
  output reg buf_empty, buf_full;
  output reg [7:0] fifo_counter;
  
  reg [3:0] rd_ptr, wr_ptr;
  reg [7:0] buf_mem[63:0];
  
  //for status flag
  always @(fifo_counter) begin
    buf_empty = (fifo_counter == 0);
    buf_full = (fifo_counter == 64);
  end
  
  //set the FIFO counter
  always @(posedge clk or posedge rst) begin
     if(rst)
        fifo_counter <= 0;
    else if((!buf_full && wr_en) && (!buf_empty && rd_en))
        fifo_counter <= fifo_counter;
      else if(!buf_full && wr_en)
        fifo_counter <= fifo_counter + 1;
      else if(!buf_empty && rd_en)
        fifo_counter <= fifo_counter - 1;
      else
        fifo_counter <= fifo_counter; // if none of the condition is true then hold the counter value
  end
  
  //fetch the data from FIFO
  always @(posedge clk or posedge rst) begin
    if(rst)
      buf_out <= 0;
    else begin
      if(!buf_empty && rd_en)
        buf_out <= buf_mem[rd_ptr];
      else
        buf_out <= buf_out;
    end
  end
  
  //writting data into FIFO
  always @(posedge clk) begin
    if(!buf_full && wr_en)
      buf_mem[wr_ptr] <= buf_in;
    else
      buf_mem[wr_ptr] <= buf_mem[wr_ptr];
  end
        
  //To manage the pointer
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
    end
    else begin
      if(!buf_full && wr_en)
        wr_ptr <= wr_ptr +1;
      else
        wr_ptr <= wr_ptr;
      
      if(!buf_empty && rd_en)
        rd_ptr <= rd_ptr +1;
      else
        rd_ptr <= rd_ptr;
    end
  end
endmodule
  
  
