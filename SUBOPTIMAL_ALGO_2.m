% The OBJECTIVE of this SUBOPTIMAL ALGORITHM 2 is to generate a subset of
% receive antennas (subset_receive_antennas) for every selected user
% (user_set) which maximizes the sum capacity and generating their
% corresponding data streams (data_streams) by treatimg each receive
% antenna as a separate candidate user to as to reduce the computational
% complexity.

clc;
close all;
clear all;

R = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15] ; % receive antenna set with ID.
S = zeros(15);
L = 0;
H_tilda = zeros(15);
W = zeros(15);
Cmax = 0;
flag = 1;
Cr = zeros(15);
Wr = zeros(15);

while flag == 1
   
    for r = R % for every receive antenna in the set R.
    
        Stmp = horzcat(S,r);
        Ltmp = L+1;
        
        % find the precoding matrix only for the candidate antenna.
        
        Wr(r) = PrecodingMatrixMax( H,L,SIGMArSQ,Ebs,j,U,r );
        
        if trace(Wr' * Wr) == 1
            
            Wtmp = horzcat(W,Wr(r));
            
            % calculate the sum capacity Cr
            
            Cr(r) = SumCapacitySA2( S,H,L,SIGMArSQ,Ebs );
            
        end    
        
    end
    
    [r_val,r_bar] = max(Cr); % generating the maximum value of sum capacity and the corresponding receive antenna value of maximum candidate antenna.
    
    if Cr(r_bar) > Cmax
       
        Cmax = Cr(r_bar);
        S = horzcat(S,r_bar);
        R(r_bar) = [];
        L = L+1; % increasing the data sreams by 1 on getting a new  r_bar value.
        
        Wr = PrecodingMatrixMax( H,L,SIGMArSQ,Ebs,j,U,r_bar ); % generating the precoding matrix for r_bar receive antenna.
        W = horzcat(W,Wr);
        
        Hr = receiveAntennaChannelVector( H,r_bar ); % generating the channel vector for r_bar receive antenna.
        H_tilda = horzcat(H_tilda,Hr);
        
    else
        
        flag = 0; % changing flag value for stop a particular loop or conditional statements.
        
    end    
    
    disp(S); % display the slected user subset S.
    
end