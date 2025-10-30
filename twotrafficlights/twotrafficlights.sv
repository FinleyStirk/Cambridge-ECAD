module twotrafficlights(
      input  logic clk,
      input  logic rst,
      output logic [2:0] lightsA, 
      output logic [2:0] lightsB
    );
  logic [2:0] state;
  // insert your code here

  always_ff @(posedge clk or posedge rst) begin
    if (rst)
        state <= 3'b0;
    else
        state <= state + 1;
  end

  always_comb begin
    lightsA[2] = ~(state[2] & (state[1] ^ state[0]));
    lightsA[1] = state[2] & ~state[0];
    lightsA[0] = state[2] & ~state[1] & state[0];

    lightsB[2] = ~(~state[2] & (state[1] ^ state[0]));
    lightsB[1] = ~state[2] & ~state[0];
    lightsB[0] = ~state[2] & ~state[1] & state[0];
  end

endmodule
