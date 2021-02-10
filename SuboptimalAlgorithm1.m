function [ S, U , l  ] = SuboptimalAlgorithm1( Nt,Nr,K )

%using SUBOPTIMAL ALGORITHM 1 for JOINT USER AND RECEIVE ANTENNA SELECTION
%to provide suboptimal results of capacity and reduce the computaional
%complexity in MULTIUSER MIMO SYSTEMS.

% OBJECTIVE of this SUBOPTIMAL ALGORITHM 1 is to generate a subset of
% receive antennas (subset_receive_antennas) for every selected user
% (user_set) which maximizes the sum capacity and generating their
% corresponding data streams (data_streams).

clc;
close all;
clear all;

% given data to execute the program.



R = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];%receive antenna complete set for all users.

S=[];        %set of receive antenna selected.
U=[];        %set of users selected.
l=0;         %data streams for user.
H_tilda=[];  %H channael vector for non candidate users.
Cmax=0;      %maximum channel capacity 
flag=1;      %variable for loop
phase=1;     %variable for conditional statements.
C=zeros(length(r));

H = channelMatrix( Mj,Nt,k); %generating the channel vector for each k users;

while flag == 1
   
    for r = R
        
        Stmp = horzcat(S,r);
        W = [];
        H = H_tilda;
        ltmp = l;
        u = UsrID_mapping( r );
        Utmp = horzcat(U,u);
        Hu = H(:,:,u); % generating channel vector for user u.
        
        if phase == 1
           
            ltmp(u)= ltmp(u) + 1;
     
        end
        
        Ltmp = sum(ltmp); % calculating the total data strems for all selected users.
        
        Mj = size(Hu , 1);
        Ej = (l(u) * Ebs ) / (Ltmp) ; % equal power per data stream (equal power allocation shcheme.)
        W(u) = precodingMatrix( k,j,U,H,Mj,SIGMAjSq,Ej,Nt,Lj); % generating precoding matrix for user u;
        if trace( W(u)' * W(u) ) == l(u) % if the precoding matrix follows the power constrain then following will be calculated.
           
            C(r) = SumCapacity(Mj,Utmp,k,SINR ); % calculating the sum capacity.
            
        end
    end 
    
    [r_max,r_bar] =max(C); % getting the value of r for which the capacity is maximum.
    
    if C(r_bar) > Cmax
       
        Cmax = C(r_bar); % assigning Cmax the maximum value of sum capacity.
        
        S = horzcat(S,r_bar); % adding r_bar to receive antenna set as it provides maximum capacity.
        R(r_bar)=[]; % removing selected receive antenna from the set of unselected receive antenna set R.
        u_bar = UsrID_mapping( r_bar );
        U = horzcat(U,u_bar);
        H_tilda(u_bar) = vertcat(H_tilda(u_bar), Hu );
        
        if phase == 1
           
            l(u_bar) = l(u_bar) + 1 ;
            
        end    
        
    elseif phase == 1
        
        % r = remaining antennas of users in U not been selected in S
        phase = 2;
        
    else
        
        flag = 0;
        
    end    
    
end

end