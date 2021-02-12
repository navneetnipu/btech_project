function [ SINR_j_l ] = CalculateSINR( ChannelMatrix,DataStream,TotalDataStreams,VarianceSq,EnergyOfBS,UserID,ChannelMatrixTilda,ReceiveAntennaID,TotalReceiveAntennaSelected,SelectedUsersSet)

H = ChannelMatrix;
Nr = size(H,1);
Hj_tilda = ChannelMatrixTilda;
l = DataStream;
L = TotalDataStreams;
v = VarianceSq;
Ebs = EnergyOfBS;
U = SelectedUsersSet;
Wj_tilda = [];
Wj = CalculatePrecodingMatrix( H,v,TotalReceiveAntennaSelected,UserID,EnergyOfUser,ReceiveAntennaID,PreviouslyselectedReceiveAntennaChannelMatrix );
for j = U
    if(j ~= UserID)
        Wj_t = CalculatePrecodingMatrix( H,v,TotalReceiveAntennaSelected,UserID,EnergyOfUser,ReceiveAntennaID,Hj_tilda );
        Wj_tilda = [Wj_tilda Wj_t];
    end
end
r = ReceiveAntennaID - ((UerID-1)*Nr) ;
Hj = H(r,:,UserID);
Dj = Wj' *  Hj' * Hj * Wj ;
Num = Dj * Dj' ;
Qj = Wj' * Hj' * Hj ;
W = Wj_tilda * Wj_tilda' ;
Dnum = ((L*v/Ebs)*Dj + Qj * W * Qj' );
Numerator = Num(l,l);
Denumerator = Dnum(l,l);

SINR_j_l = Numerator / Denumerator ;

end