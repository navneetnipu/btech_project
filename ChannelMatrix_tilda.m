function [ Hj_tilda ] = ChannelMatrix_tilda(j,U,H)

%generates the verticle concatination of channel matrix of all users except the jth user given by using vertcat operation.

Hj_tilda = [];

for i = U
    if i ~= j
        
        Hj_tilda = Hj_tilda + ( H(:,:,i)' * H(:,:,i) ) ; % summation of all channel vectors of K users where K not equal to j.
        
    end

end

