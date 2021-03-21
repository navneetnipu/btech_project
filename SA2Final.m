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
ChannelMatrix = sqrt(1/2)*randn(Nr,Nt,k) + sqrt(1/2)*randn(Nr,Nt,k)*1i;
R = rx;
S = [];
U = [];
L = 0;
H_tilda = zeros(Nr,Nt);
W = [];
Cmax = 0;
flag = 1;
Cr = zeros(1,Nr*k);
Wr = [];
while flag == 1
    Cr = zeros(1,Nr*k);
    if L < Nt
        for r = R
            Csum = 0;
            Stmp = union(S,r);
            Ltmp = L+1;
            H = H_tilda' * H_tilda ;
            u = UserId(r);
            r_id = r - ((u-1)*Nr);
            hr = ChannelMatrix(r_id,:,u);
            Wr(:,r) = eigs(inv(( Ltmp * v / Ebs )*eye( size(H,2) ) + H ) * ( hr' * hr)  , Nt) ;
            Wtmp = [W Wr(:,r)];
            for i = Stmp
                ui =UserId(i);
                i_id = i-((ui-1)*Nr);
                hi = ChannelMatrix(i_id,:,ui) ;
                hiWtmpi = (norm(hi * Wr(:,i))) ^ 2;
                hiWtmp = 0;
                for l_bar = Stmp
                    if l_bar ~= i
                        hiWtmp = hiWtmp + (norm(hi * Wr(:,l_bar))) ^ 2;
                    end
                end
                Csum = Csum + log2( 1 + ( (hiWtmpi) / ( ( Ltmp * v / Ebs ) + ( hiWtmp ) ) ) ) ;
            end
            Cr(r) = Csum ;
        end
        [r_val,r_bar] = max(Cr);
        if Cr(r_bar) > Cmax
            Cmax = Cr(r_bar);
            S = union(S,r_bar);
            U = union(U,UserId(r_bar));
            R = setdiff(R,r_bar);
            L = L+1;
            W = [W Wr(:,r_bar)];
            r_bar_id = r_bar - ((UserId(r_bar) -1)*Nr) ;
            Hr = ChannelMatrix(r_bar_id,:,UserId(r_bar));
            H_tilda( ~any(H_tilda,2), : ) = [];
            H_tilda = [H_tilda;Hr];
        else
            flag = 0;
        end
    else
        flag = 0;
    end
end


disp('the output of the SUBOPTIMAL ALGORITHM 2 are---- ');
disp('selected receive antenna IDs are:');
disp(S);
disp('selected user IDs are:');
disp(U);
disp('total data streams to be transmitted are:');
disp(L);
% -----------------------END OF PROGRAM------------------------------------