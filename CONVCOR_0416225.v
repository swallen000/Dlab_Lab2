module CONVCOR(	
	clk, 
	rst_n, 
	in_valid, 
	in_a,
	in_b,
	in_mode,	
	out_valid, 
	out
);
				
//---------------------------------
//  input and output declaration
//---------------------------------  

input              clk;
input              rst_n;
input              in_valid;
input 	[15:0]     in_a;
input 	[15:0]     in_b;
input 	           in_mode;
output  reg        out_valid;
output  reg [35:0] out;


//----------------------------------
// reg and wire declaration
//--------------------------------- 
reg signed [7:0]ar1,ar2,ar3,ai1,ai2,ai3,br1,br2,br3,bi1,bi2,bi3;
reg [1:0]inmode,k,j,ali;
reg [4:0]run,count,tmp;
reg signed [15:0]abc,nba;
reg signed [15:0]a1,a2,a3,b1,b2,b3;

always@(posedge clk)
	begin
	if(~rst_n)
	  begin
		a1=0;
		a2=0;
		a3=0;
		b1=0;
		b2=0;
		b3=0;
		k=0;
		tmp=1;
	  end
	if(ali==1)
	  begin
		tmp=1;
	  end
	if(in_valid==1)
	  begin 
		if(tmp==1)
		  begin 
			a1=in_a;
			b1=in_b;
			ar1=a1[15:8];
			ai1=a1[7:0];
			br1=b1[15:8];
			bi1=b1[7:0];
			tmp=tmp+1;
			inmode=in_mode;
		  end
		else if(tmp==2)
		  begin 
			a2=in_a;
			b2=in_b;
			ar2=a2[15:8];
			ai2=a2[7:0];
			br2=b2[15:8];
			bi2=b2[7:0];
			tmp=tmp+1;
		  end
		else if(tmp==3) 
		  begin 
			a3=in_a;
			b3=in_b;
			ar3=a3[15:8];
			ai3=a3[7:0];
			br3=b3[15:8];
			bi3=b3[7:0];
			tmp=tmp+1;
			k=1;
		  end
	  end
	end	
always@(posedge clk)
	begin
	if(~rst_n)
	  begin
		out=0;
		out_valid=0;
		run=0;
		j=0;
		ali=0;
	  end
	ali=0;
	if(in_valid==0&&tmp==4&&k==1)
		  begin
			if(inmode==1)
			  begin
				out_valid=1;
				out[35:18]=(ar1*br1+ar2*br2+ar3*br3+ai1*bi1+ai2*bi2+ai3*bi3);
				out[17:0]=(((-1)*(ar1*bi1+ar2*bi2+ar3*bi3))+ai1*br1+ai2*br2+ai3*br3);
				run=5;
			  end
			else if(inmode==0)
			  begin
				ali=0;
				out_valid=1;
				case(run)
				0:  
					begin
					out[35:18]=(ar1*br1)-(ai1*bi1);
					out[17:0]=((ar1*bi1)+(ai1*br1));
					run=run+1;
					end
				1:  
					begin
					out[35:18]=((ar1*br2+ar2*br1)-(ai1*bi2+ai2*bi1));
					out[17:0]=((ar1*bi2+ar2*bi1)+(ai1*br2+ai2*br1));
					run=run+1;
					end
				2:  
					begin
					out[35:18]=((ar1*br3+ar2*br2+ar3*br1)-(ai1*bi3+ai2*bi2+ai3*bi1));
					out[17:0]=((ar1*bi3+ar2*bi2+ar3*bi1)+(ai1*br3+ai2*br2+ai3*br1));
					run=run+1;
					end
				3:  	
					begin
					out[35:18]=((ar2*br3+ar3*br2)-(ai2*bi3+ai3*bi2));
					out[17:0]=((ar2*bi3+ar3*bi2)+(ai2*br3+ai3*br2));
					run=run+1;
					end
				4:  
					begin
					out[35:18]=((ar3*br3)-(ai3*bi3));
					out[17:0]=((ar3*bi3)+(ai3*br3));
					run=run+1;
					end
				endcase
			  end
			if(j==0&&tmp==4&&run==5)
				j=1;			
			else if(j==1)
		 	 begin
				out_valid=0;
				out=0;
				run=0;
				ali=1;
				j=0;
		  	end
		  end
	end
	
 
 //----------------------------------
//
//         My design
//
//----------------------------------


endmodule
