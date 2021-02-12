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
S = zeros(Nr*k);
U = zeros(1,k);
L = 0;
H_tilda = [];
W = [];
Cmax = 0;
flag = 1;
Cr = zeros(1,Nr*k);
Wr = zeros(1,Nr*k);          

while flag == 1   
    for r = R    
        Stmp = union(S,r);
        Ltmp = L+1;       
        H = H_tilda' * H_tilda ;
        u = UserId(r);
        r_id = r - ((u-1)*Nr);
        hr = ChannelMatrix(r_id,:,u);
        Wr(r) = eigs( inv(( Ltmp * v / Ebs )*eye( size(H) ) + H ) * ( hr' * hr ) ) ; % error inner dimension must agree.
        if trace(Wr' * Wr) == 1
            Wtmp = union(W,Wr(r));            
            for i = Stmp    
                  ui =UserId(i);
                  hi = ChannelMatrix(i,:,ui) ; 
                  hiWtmpi = square(norm(hi * Wtmp(:,i)));
                  hiWtmp = 0;
                  for l_bar = Stmp
                      if l_bar ~= i
                          hiWtmp = hiWtmp + square(norm(hi * Wtmp(:,l_bar)));
                      end
                  end
                  Csum = Csum + log2( 1 + ( (hiWtmpi) / ( ( Ltmp * v / Ebs ) + ( hiWtmp ) ) ) ) ;
            end          
            Cr(r) = Csum ;            
        end            
    end    
    [r_val,r_bar] = max(Cr); 
    if Cr(r_bar) > Cmax       
        Cmax = Cr(r_bar);
        S = union(S,r_bar);
        U = union(U,UserId(r_bar));
        R = setdiff(R,r_bar);
        L = L+1;     
        W = [W Wr(r_bar)]; 
        Hr = ChannelMatrix(r_bar,:,UserId(i));
        H_tilda = [H_tilda;Hr];        
    else       
        flag = 0; 
    end    
end
disp('\nthe output of the SUBOPTIMAL ALGORITHM 1 are---- ');
disp('\nselected receive antennas are:',S);
disp('\nselected users are:',U);
disp('\ntotal data streams to be transmitted are:',L);
% -----------------------END OF PROGRAM------------------------------------