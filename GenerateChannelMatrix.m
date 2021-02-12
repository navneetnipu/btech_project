function [ ChannelMatrix ] = GenerateChannelMatrix( NumOfReceiveAntenna ,NumOfTransmitAntenna,NumOfUsers )

Nr = NumOfReceiveAntenna;
Nt = NumOfTransmitAntenna;
k = NumOfUsers;

ChannelMatrix = sqrt(1/2)*randn(Nr,Nt,k) + sqrt(1/2)*randn(Nr,Nt,k)*1i;

end

