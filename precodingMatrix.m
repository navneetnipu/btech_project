function [ Wj ] = precodingMatrix( k,j,U,H,Mj,SIGMAjSq,Ej,Nt,Lj)

% here we are generating the precoding matrix for every selected user so as
% to make sure that the receiving end will receive the proper required
% signal without high post receiving calculation.

% we use following inputs for our function to work
%j = the jth selected user identification
%Hj = channel matrix for selected user j
%Mj = number of selected receive antennas for user j from a set of Nr,j
%receiving antennas of user j
%SIGMAj = variance of the complex gaussian additive noise
%Ej = energy for user j
%Nt = number of transmit antennas involved in transmitting the signal
%Lj = data streams for selected user j

for j = U
    

Hj_tilda = ChannelMatrix_tilda(j,U,H);
    
Wj = eig((H(:,:,j)' * H(:,:,j) ),((Mj*SIGMAjSq/Ej)*eye(Mj *(k-1))) + (Hj_tilda) );

% generates precoding matrix for user j.

end

end

