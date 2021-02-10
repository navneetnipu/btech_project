function [ UserID ] = UsrID_mapping( r )

% mapping user with its corresponding receive antennas.

rx = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];% receive antenna ID
usr = [1 1 1 2 2 2 3 3 3 4 4 4 5 5 5]; % user ID 
userId = containers.Map(rx,usr);

UserID = userId(r); % getting the user ID for the given receive antenna.

end

