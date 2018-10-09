// Encoder/Decoder for Dense Packed Decimal

// Decode 3 dense pack digits into 3 BCD digits
// if error BCD=FFF which is, of course, illegal

// We assume the synthesis tool is good enough
// to relize that dpd[0] always goes to digit0[0]
// dpd[4] and dpd[7] go to digit 1 & 2 [0] also

module dpddecode(input [9:0] dpd, output reg [3:0] digit2, output reg [3:0] digit1, output reg [3:0] digit0);
 always @(*)
 begin
    casez ({dpd[6:5],dpd[3:1]})
      5'b??0??: // 000 case
        begin
  	  digit2={1'b0,dpd[9:7]};
  	  digit1={1'b0,dpd[6:4]};
	  digit0=dpd[3:0];  // note dpd3 must be zero!
	end
      5'b??100:  // 001 case
      begin	
	digit2={1'b0,dpd[9:7]};
	digit1={1'b0,dpd[6:4]};
	digit0={3'b100,dpd[0]};
      end
      5'b??101:  // 010 case
      begin	
	digit2={1'b0,dpd[9:7]};
	digit1={3'b100,dpd[4]};
	digit0={1'b0,dpd[6:5],dpd[0]};
      end
      5'b??110:  // 100 case
      begin	
	digit2={3'b100,dpd[7]};
	digit1={1'b0,dpd[6:4]};
	digit0={1'b0,dpd[9:8],dpd[0]};
      end
      
      5'b00111:   // 110 case
      begin	
	digit2={3'b100,dpd[7]};
	digit1={3'b100,dpd[4]};
	digit0={1'b0,dpd[9:8],dpd[0]};
      end
      5'b01111:   // 101 case
      begin	
	digit2={3'b100,dpd[7]};
	digit1={1'b0,dpd[9:8],dpd[4]};
	digit0={3'b100,dpd[0]};
      end

      5'b10111:  // 011 case
      begin	
	digit2={1'b0,dpd[9:7]};
	digit1={3'b100,dpd[4]};
	digit0={3'b100,dpd[0]};
      end
      5'b11111:  // 111 case
      begin
         digit2={3'b100,dpd[7]};
	 digit1={3'b100,dpd[4]};
	 digit0={3'b100,dpd[0]};
      end
      default:  // catch all just in case
        begin
        digit2=4'b1111;
        digit1=4'b1111;
        digit0=4'b1111;
        end
    endcase
 end
 
endmodule



module dpdencode(input [3:0] digit2, input [3:0] digit1,
                 input [3:0] digit0, output reg [9:0] dpd);
  
  
// Note that we hope the synth tool figures out that digit2[0] is always dpd[0],
// digit1[0] is always dpd[4], and digit2[0] is always dpd[7]
// If you were really worried about space, you could verify that and recode if it
// doesn't. But you'd think it should
  
  always @(*)
    begin
      case ({digit2[3],digit1[3],digit0[3]})
        3'b000:
          dpd={digit2[2:0],digit1[2:0],1'b0,digit0[2:0]};
        3'b001:
          dpd={digit2[2:0],digit1[2:0],3'b100,digit0[0]};
        3'b010:
          dpd={digit2[2:0],digit0[2:1],digit1[0],3'b101,digit0[0]};
        3'b100:
          dpd={digit0[2:1],digit2[0],digit1[2:0],3'b110,digit0[0]};
        3'b110:
   	  dpd={digit0[2:1],digit2[0],2'b00,digit1[0],3'b111,digit0[0]};
	3'b101:
	  dpd={digit1[2:1],digit2[0],2'b01,digit1[0],3'b111,digit0[0]};
	3'b011:
	  dpd={digit2[2:0], 2'b10,digit1[0],3'b111,digit0[0]};
	3'b111:
	  dpd={2'b00,digit2[0],2'b11,digit1[0],3'b111,digit0[0]};
          endcase
    end
  
  
endmodule // dpdencode
