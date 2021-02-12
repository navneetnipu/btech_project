function [ PrecodingMatrix ] = CalculatePrecodingMatrix( ChannnelMatrix,VarianceSq,TotalReceiveAntennaSelected,UserID,EnergyOfUser,ReceiveAntennaID,PreviouslyselectedReceiveAntennaChannelMatrix )

H = ChannnelMatrix;
v = VarianceSq;
Nt = size(H,2);
Nr = size(H,1);
Ej = EnergyOfUser;
r = ReceiveAntennaID -( (UserID-1)*Nr);
j = UserID;
H_tilda = PreviouslyselectedReceiveAntennaChannelMatrix ;
Mj = TotalReceiveAntennaSelected;
H1 = H(r,:,j)' * H(r,:,j); 
H2 = H_tilda' * H_tilda ;
Wj = eig(H1 , (Mj*v/Ej)*eye(Nt) + H2);
PrecodingMatrix = Wj;
end

