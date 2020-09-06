clc;
clear all;
close all;
% f(x)=1+2*x-x^2

n=5;
R1=rand(1,n);
R2=rand(1,n);
Xo=10*(R1-0.5);
Vo=R2-0.5;
CP=Xo;
CFo=1+2*Xo-Xo.^2;
%for loop
for i=1:n
    CF=1+2*CP-CP.^2;
    [LBF, LBP, GBP , GBF]=LocalBestPosition( CP,Xo,CF,CFo,n);
    V=VelocityVector(R1,R2,CP,Vo,LBP,GBP);
    Vo=V;
    CP=CurrentPosition(CP,Vo);
    Xo=LBP;
    CFo=LBF;
end
fplot(@(x) (1+2*x-x.^2),'b')
hold on
fplot(@(x) 2,'g')
hold on
fplot(@(x) GBF,'r')
hold off
grid on
