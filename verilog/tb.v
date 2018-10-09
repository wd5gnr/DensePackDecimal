// Code your testbench here
// or browse Examples
module tb();
  
  integer i,j,k;
  integer n;
  
  reg [3:0] i2,i1,i0;
  wire [3:0] o2,o1,o0;
  wire fail;
  wire[9:0] dpdval;
  
  assign fail=o2!=i2||o1!=i1||o0!=i0;
  
  
  dpdencode u1(i2,i1,i0,dpdval);
  dpddecode u2(dpdval,o2,o1,o0);
  
  
  initial
    begin
      $dumpfile("dumpvars.vcd");
      $dumpvars;
      for (i=0;i<=9;i++)
        for (j=0;j<=9;j++)
          for (k=0;k<=9;k++)
            begin
              i2=i;
              i1=j;
              i0=k;
              #5; 
              $display("%x = %d%d%d / %d%d%d",dpdval,i,j,k,o2,o1,o0);
              if (fail) 
                begin
                  $display("Failed");
                  $finish;
                end
             end
      $display("Success");
      $finish;
    end
  
  
endmodule
