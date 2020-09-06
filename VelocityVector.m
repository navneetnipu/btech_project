function [ V ] = VelocityVector( R1,R2,CP,Vo,LBP,GBP )
C1=0.20;
C2=0.60;
W=0.70;
V=W*Vo + C1.*R1.*(LBP-CP) + C2.*R2.*(GBP-CP);
end

