function [ HqWq ] = HqWqGeneration( U,r,H)

% generating the sum of product non candidate H and W vector for candidate
% receive antenna r .

for q = U
    
    if q ~= r
            
            Hq = receiveAntennaChannelVector( H,q ) ; % H vector for non candidate antenna.
    
            Wq = PrecodingMatrixMax( H,L,SIGMArSQ,Ebs,j,U) ; % W vector for non candidate antenna.
            
            HqWq = HqWq + square(norm(Hq * Wq)) ;% summation of square of normed value of product of H and W for non candidate antenna.
            
        end

end

