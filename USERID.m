function [ UserID ] = USERID( ReceiveAntennaID, ReceiveAntennaIndices,UserIDs )

rx = ReceiveAntennaIndices;
user = UserIDs;
r = ReceiveAntennaID;
userId = containers.Map(rx,user);
UserID = userId(r);

end

