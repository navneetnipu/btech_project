clc;
clear all;
close all;
disp('Enter the data for the mu mimo single downlink system-----');
NumOfTransmitAntennas = input('\nEnter the values for number of transmit antennas Nt:');
NumOfReceiveAntennasPerUser = input('\nnumber of receive antennas per user Nr:');
VarianceSq = input('\nEnter the value for the variance square for the complex gaussian zero mean random variables :');
NumOfUsers = input('\nEnter the value for total number of users :');
SNRindB = input('\nEnter the value for SNR in dB :');
Nt = NumOfTransmitAntennas;
Nr = NumOfReceiveAntennasPerUser;
v = VarianceSq;
k = NumOfUsers;
SNR = power(10,SNRindB/10);
Ebs =SNR * v;
rx = zeros(1,k*Nr);
user = zeros(1,k*Nr);
for i = 1:(k*Nr)
    rx(i) = i;
    user(i) =floor( (i-1)/Nr) + 1;
end    
UserId = containers.Map(rx,user);
H = sqrt(1/2)*randn(Nr,Nt,k) + sqrt(1/2)*randn(Nr,Nt,k)*1i;
S=[];        
U=[];           
H_tilda=zeros(Nr,Nt); 
Cmax=0; 
Cr = zeros(1,Nr*k);
L=zeros(1,k);
ltmp = zeros(1,k);
flag=1;      
phase=1;      
while flag == 1
    for r = rx    
         C = zeros(1,k);
        Stmp = union(S,r);
        W = [];
        u = UserId(r);
        r_id = r - ((u-1)*Nr);
        Utmp = union(U,u); 
        if phase == 1
            ltmp(u)= ltmp(u) + 1;
        end
        Ltmp = sum(ltmp(u));
        for j = Utmp
            H1 = H(r_id,:,j)' * H(r_id,:,j); 
            H2 = H_tilda' * H_tilda ;
            Mj = size(H(r_id,:,j),1); 
            Ej = ((Ebs * ltmp(j)) / Ltmp );
            Wj = zeros(Nt,ltmp(j));
            Wj = eig(H1 , (Mj*v/Ej)*eye(size(H1,2)) + H2); 
            Wj_tilda = zeros(Nt,ltmp(j));
            for user = Utmp
                if(user ~= j)
                    H11 = H(r_id,:,user)' * H(r_id,:,user); 
                    H22 = H_tilda(user)' * H_tilda(user) ;
                    Wj_t = eig(H11 , (Mj*v/Ej)*eye(Nt) + H22);
                    Wj_tilda = [Wj_tilda Wj_t];
                end
            end
            for l = 1:ltmp(j)
               Hj = H(r_id,:,j);
               Dj = Wj' * (( Hj' * Hj) * Wj) ;
               Num = Dj * Dj' ;
               Qj = Wj' * Hj' * Hj ;
               Dnum = ((Ltmp * v / Ebs) * Dj + ( Qj * (Wj_tilda * Wj_tilda') * Qj') );
               Numerator = Num;
               Denumerator = Dnum;
               SINR_j_l = Numerator / Denumerator ;
               C(j) = C(j) + log2( 1 + SINR_j_l ) ;
            end          
        end
        Cr(r) = sum(C);
    end 
    [r_max,r_bar] = max(Cr);     
    if Cr(r_bar) > Cmax
        Cmax = Cr(r_bar);
        S = union(S,r_bar);
        u_bar = UserId(r_bar);
        rx = setdiff(rx,r_bar);
        U = union(U,u_bar);
        r_bar_ID = r_bar - ((u_bar-1)*Nr);
        H_tilda = [H_tilda; H(r_bar_ID,:,u_bar) ]; 
        if phase == 1 
            L(u_bar) = L(u_bar) + 1 ;   
        end    
    elseif phase == 1
        % rx = receive antennas of U not selected in S.
        rs = [];
        for x = rx
            if (ismember(UserId(x),U) == 1) && (~ismember(x,S) == 1)
                rs = union(rs,x);
            end
        end
        rx = rs;
        phase = 2;
    else
        flag = 0;
    end    
end
disp('the output of the SUBOPTIMAL ALGORITHM 1 are---- ');
disp('selected receive antenna IDs are:');
disp(S);
disp('selected user IDs are:');
disp(U);
disp('total data streams to be transmitted are:');
disp(sum(L));
% -----------------------END OF PROGRAM------------------------------------