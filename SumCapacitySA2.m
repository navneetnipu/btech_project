function [ Csum ] = SumCapacitySA2( S,H,L,SIGMArSQ,Ebs )

% calculating the sum capacity for the users selected in SUBOPTIMAL
% ALGORITHM 2 considering each receive antenna as a individual antenna .

% initialization

Csum = 0;
HqWq = 0;

% finding the Hr,Wr,Hq,Wq matrices for calculation of sum capacity.

for r = S % for every r in subset S received from input.

    %first calculating the H and W for given value of r that is the
    %candidate antenna.
    
    Hr = receiveAntennaChannelVector( H,r ) ;
    
    Wr = PrecodingMatrixMax( H,L,SIGMArSQ,Ebs,j,U) ;
    
    % now calculating the H and W for receive antenna other than the given candidate receive antenna. 

    HqWq = HqRqGeneration( U,r,H) ;
    HqWq = square(norm(HqWq)) ;
    
    HrWr = square(norm(Hr * Wr)) ;% square of the normed value of H and W for the candidate receive antenna. 
    
    Csum = Csum + log2( 1 + ( (HrWr) / ( ( L*SIGMArSQ/Ebs ) + ( HqWq ) ) ) ) ;


end
    
end

