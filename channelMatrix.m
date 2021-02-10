function [ H ] = channelMatrix( Mj,Nt,k)
% here we generate k channel matrices for corresponding user's
% receive antenna Mj and it will have Nt number of columns and Mj number of
% rows

H = sqrt(1/2)*randn(Mj,Nt,k) + sqrt(1/2)*randn(Mj,Nt,k)*1i; % generating normal distribution of random numbers.

%generates channel matrix for k users.

end

