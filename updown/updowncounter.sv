module updowncounter
  (
   input logic        clk,
   input logic        rst,
   input logic        up,
   output logic [3:0] count
   );

   // insert your code here
   always_ff @(posedge clk or posedge rst) begin
      if(rst)
        count <= 4'd0;
      else if (up)
        count <= count + 1;
      else
        count <= count - 1;
   end
endmodule
