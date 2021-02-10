function [ Hr ] = receiveAntennaChannelVector( H,r )

% generating channel vector for each given receive antenna.

    if rem(r,3) == 0
        
        R = r/3 ;
        user = UsrID_mapping( R );
        Hr = H(R,:,user) ; % treating each receive antenna as a separate user.
        
    elseif rem(r,3) ~= 0
            R = rem(r,3);
            user = UsrID_mapping( R );
            Hr = H(R,:,user) ; % treating each receive antenna as a separate user.
    end

end

