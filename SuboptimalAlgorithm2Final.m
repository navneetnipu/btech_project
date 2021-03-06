function [SumCapacity,SelectedReceiveAntenna,SelectedUser,DataStreams ] = SuboptimalAlgorithm2Final( NumOfTransmitAntennas,NumOfReceiveAntennasPerUser, VarianceSq,NumOfUsers,SNRindB )

% Delcaration

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

% Mapping of user and receive antennas

UserId = containers.Map(rx,user);

% generating full channel matrix

ChannelMatrix = sqrt(1/2)*randn(Nr,Nt,k) + sqrt(1/2)*randn(Nr,Nt,k)*1i;

% Iitialization

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

% Algorithm Starts

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
            
            % generating the Precoding matrix for receive antenna r
            
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
                        
                        % generating the Tilda of Precoding matrix for user
                        % r
                        
                        hiWtmp = hiWtmp + (norm(hi * Wr(:,l_bar))) ^ 2;
                    end
                end
                
                % calculating the Sum capacity for receive antenna r
                
                Csum = Csum + log2( 1 + ( (hiWtmpi) / ( ( Ltmp * v / Ebs ) + ( hiWtmp ) ) ) ) ;
            end
            Cr(r) = Csum ;
        end
        
         % finding the receive antenna which provides maximum sum capacity
        
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
            
            % updating H tilda matrix
            
            H_tilda = [H_tilda;Hr];
        else
            flag = 0;
        end
    else
        flag = 0;
    end
end

% generaing the required output

SumCapacity = Cmax;
SelectedReceiveAntenna = S;
SelectedUser = U;
DataStreams = L;

end
% -----------------------END OF PROGRAM------------------------------------