function [ Csum ] = SumCapacity(Lj,U,k,SINR )

%here we will calculate the sum capacity for selected users j in U from 
%the given SINR value for user j using the below fromula.

% initialization

Cj = zeros(k);
Csum = 0;

for j=U % for every user j
    for i = 1:Lj(j) % for every data stream upto Lj
        
         Cj(j) = Cj(j) + log2(1 + (SINR( j,i ) ) ) ; % capacity for user j belongs to U;
         
    end
    
    Csum = Csum + Cj(j); % sum capacity for all the selected users in U .
    
end

end

