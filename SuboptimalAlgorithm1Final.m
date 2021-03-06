function [ SumCapacity,SelectedReceiveAntenna,SelectedUser,DataStreams ] = SuboptimalAlgorithm1Final( NumOfTransmitAntennas,NumOfReceiveAntennasPerUser, VarianceSq,NumOfUsers,SNRindB)

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

Hf = sqrt(1/2)*randn(Nr,Nt,k) + sqrt(1/2)*randn(Nr,Nt,k)*1i;

% Iitialization

S=[];
U=[];
H_tilda=zeros(Nr,Nt);
Cmax=0;
L=zeros(1,k);
ltmp = zeros(1,k);
flag=1;
phase=1;

% Algorithm Starts

while flag == 1
    if sum(L)< Nt
        Cr = zeros(1,Nr*k);
        H = zeros(Nr,Nt,k);
        for r = rx
            ltmp = L;
            Stmp = union(S,r);
            u = UserId(r);
            r_id = r - ((u-1)*Nr);
            Utmp = union(U,u);
            H(r_id,:,u) = Hf(r_id,:,u);
            
            % Increasing the Data Steams for each user u for r
            
            if phase == 1
                ltmp(u)= ltmp(u) + 1;
            end
            
            % Total Data streams
            
            Ltmp = sum(ltmp);
            C = zeros(1,k);
            Hz = zeros(Nr,Nt);
            for j = Utmp
                Hz = H(:,:,j);
                Hz( ~any(Hz,2), : ) = [];
                H1 = Hz' * Hz ;
                H2 = H_tilda' * H_tilda;
                Mj = size(Hz,1);
                Ej = ((Ebs * ltmp(j)) / Ltmp );
                
                % Precoding matrix calculation for user j
                
                Wj = eig(H1 , (Mj*v/Ej)*eye(size(H1,1)) + H2);
                Wj_tilda = zeros(Nt,ltmp(j));
                Hz1 = zeros(Nr,Nt);
                for user1 = Utmp
                    
                    % Calculating the tilda of Precoding Matrix for user j
                    
                    if user1 ~= j
                        Hz1 = H(:,:,user1);
                        Hz1( ~any(Hz1,2), : ) = [];
                        H11 = Hz1' * Hz1 ;
                        H22 = H_tilda' * H_tilda;
                        Wj_t = eig(H11 , (Mj*v/Ej)*eye(size(H11,2)) + H22);
                        Wj_tilda( :,~any(Wj_tilda,1) ) = [];
                        Wj_tilda = [Wj_tilda Wj_t];
                    end
                end
                Hzj = zeros(Nr,Nt);
                
                % Calculating SINR value for each Lj
                
                for l = 1:ltmp(j)
                    Hzj = H(:,:,j);
                    Hzj( ~any(Hzj,2), : ) = [];
                    Hj = Hzj;
                    Dj = Wj' *  Hj' * Hj * Wj ;
                    Num = Dj * Dj' ;
                    Qj = Wj' * Hj' * Hj ;
                    Wj_tilda(:, ~any(Wj_tilda,1) ) = [];
                    Dnum = ((Ltmp * v / Ebs) * Dj + ( Qj * Wj_tilda * Wj_tilda' * Qj') );
                    Numerator = Num;
                    Denumerator = Dnum;
                    SINR_j_l = Numerator / Denumerator ;
                    
                    % Calculating capacity for user j
                    
                    C(j) = C(j) + log2( 1 + SINR_j_l ) ;
                end
            end
            
            % Calculating Sum Capacity for r receive antenna 
            
            Cr(r) = sum(C);
        end
        
        % finding the receive antenna which provides maximum sum capacity
        
        [r_max,r_bar] = max(Cr);
        if Cr(r_bar) > Cmax
            Cmax = Cr(r_bar);
            S = union(S,r_bar);
            u_bar = UserId(r_bar);
            rx = setdiff(rx,r_bar);
            U = union(U,u_bar);
            r_bar_ID = r_bar - ((u_bar-1)*Nr);
            H_tilda( ~any(H_tilda,2), : ) = [];
            
            % updating H tilda matrix
            
            H_tilda = [H_tilda; H(:,:,u_bar) ];
            
            % updating the Data stream matrix of user u_bar which is
            % selected
            
            if phase == 1
                L(u_bar) = L(u_bar) + 1 ;
            end
        elseif phase == 1
            rs = [];
            for x = rx
                if ismember(UserId(x),U) == 1
                    rs = union(rs,x);
                end
            end
            rx = rs;
            phase = 2;
        else
            flag = 0;
        end
    else
        flag=0;
    end
end

% generaing the required output

SumCapacity = Cmax;
SelectedReceiveAntenna = S;
SelectedUser = U;
DataStreams = sum(L);
end
% -----------------------END OF PROGRAM------------------------------------