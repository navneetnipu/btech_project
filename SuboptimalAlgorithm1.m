function [ SumCapacity,SelectedReceiveAntenna,SelectedUser,DataStreams ] = SuboptimalAlgorithm1( NumOfTransmitAntennas,NumOfReceiveAntennasPerUser, VarianceSq,NumOfUsers,SNRindB)

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
Hf = sqrt(1/2)*randn(Nr,Nt,k) + sqrt(1/2)*randn(Nr,Nt,k)*1i;
S=[];        
U=[];         
H_tilda=zeros(Nr,Nt); 
Cmax=0; 
L=zeros(1,k);
ltmp = zeros(1,k);
flag=1;      
phase=1;
while flag == 1  
   if length(S)< Nt
    Cr = zeros(1,Nr*k);
    H = zeros(Nr,Nt,k);
    ltmp = L;
    for r = rx  
        Stmp = union(S,r);
        u = UserId(r);
        r_id = r - ((u-1)*Nr);
        Utmp = union(U,u); 
        H(r_id,:,u) = Hf(r_id,:,u); 
        if phase == 1
            ltmp(u)= ltmp(u) + 1;
        end
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
            Wj = eig(H1 , (Mj*v/Ej)*eye(size(H1,2)) + H2); 
            Wj_tilda = zeros(Nt,ltmp(j));
            Hz1 = zeros(Nr,Nt);
            for user1 = Utmp
                if user1 ~= j
                    Hz1 = H(:,:,user1);
                    Hz1( ~any(Hz1,2), : ) = [];
                    H11 = Hz1' * Hz1 ; 
                    H22 = H_tilda' * H_tilda;
                    Wj_t = eig(H11 , (Mj*v/Ej)*eye(size(H11,2)) + H22);
                    Wj_tilda = [Wj_tilda Wj_t];
                end
            end
            Hzj = zeros(Nr,Nt);
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
        H_tilda( ~any(H_tilda,2), : ) = [];
        H_tilda = [H_tilda; H(:,:,u_bar) ]; 
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

SumCapacity = Cmax;
SelectedReceiveAntenna = S;
SelectedUser = U;
DataStreams = sum(L);
end
% -----------------------END OF PROGRAM------------------------------------