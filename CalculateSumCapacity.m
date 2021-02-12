function [ SumCapacity ] = CalculateSumCapacity( SelectedUserSet,DataStreamMatrix,ChannelMatrix,PrecodingMatrix,VarianceSq,EnergyOfBS,PrecodingmatrixTilda,ReceiveAntennaID )

U = SelectedUserSet;
Lj = DataStreamMatrix;
C = zeros(1,length(U));
L = sum(Lj);

for j = U
    for l = 1:Lj(j)
        SINR_j_l = CalculateSINR( ChannelMatrix,DataStream,TotalDataStreams,VarianceSq,EnergyOfBS,UserID,ChannelMatrixTilda,ReceiveAntennaID );
        C(j) = C(j) + log2( 1 + SINR_j_l ) ;
    end
end
    
SumCapacity = sum(C);
    
end