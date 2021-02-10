function [ SINR ] = SINR( Nt,k,U,Lj,L,Ebs,SIGMAjsq )

%here we will calculate the signal to interference and noise ratio i.e.
%SINR for a particular selected user j using the received input data and
%formula as below-

SINR=zeros(k,Lj);

for j = U
    
    Hj =channelMatrix( :,:,j); % finding jth user channel vector.
    
    Wj = precodingMatrix( k,j,U,H,Mj,SIGMAjSq,Ej,Nt,Lj) ; % finding jth user precoding matrices.
    
    Wj_tilda = PrecodingMatrix_tilda( j,U); % finding tilda of precoding matrices for user j.
    
    Dj = Wj' * Hj' * Hj * Wj ; % diagonal matrix
    Qj = Wj' * Hj' * Hj ;
    
    for l = 1:Lj(j)
        
        D = Dj * Dj' ;
        
        Dr = (L*SIGMAjsq/Ebs)*Dj + Qj * Wj_tilda * Qj' ;
        
        SINR(j,l) = D(l,l) / Dr(l,l) ; % calculating SINR value for user j for every data stream upto Lj.
        
    end
    
end

end

