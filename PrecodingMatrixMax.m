function [ Wr ] = PrecodingMatrixMax( H,L,SIGMArSQ,Ebs,j,U,r )

% generating precoding matrix for SUBOPTIMAL ALGORITHM 2 considering each receive antenna as a user.

Hr = receiveAntennaChannelVector( H,r ) ; % generating channel vector for r receive antenna treating it as a separate candidate antenna.

% generating the non candidate receive antenna channel vector.

for q = U
    
    if q ~= r
        
       Hq = receiveAntennaChannelVector( H,q ) ;
       H = H + (Hq' * Hq) ;
       
    end
end

Wr = eigs( inv(( L*SIGMArSQ/Ebs )*eye( 1 ) + H ) * ( Hr' * Hr ) ) ; % generating the precoding matrix for user j using max eigen vector.

end