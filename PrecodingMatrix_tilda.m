function [ Wj_tilda ] = PrecodingMatrix_tilda( j,U,Lj)

%generates the horizontal concatination of precoding matrices of all users except the jth user given by performing horzcat operation.

Wj_tilda = [];

for i = U
    if i ~= j
        
        Wj = precodingMatrix( k,j,U,H,Mj,SIGMAjSq,Ej,Nt,Lj) ; % finding the precoding matrices for user j.
        
        Wj_tilda = Wj_tilda + ( Wj * wj' ); % summation of precoding matrices of users k where k not equal to j.
        
    end

end


end

