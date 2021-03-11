clc;
clear all;
close all;

% Taking user input.

disp('Enter the data for the mu mimo single downlink system-----');
NumOfTransmitAntennas1 = input('\nEnter the values for number of transmit antennas Nt:');
NumOfReceiveAntennasPerUser1 = input('\nnumber of receive antennas per user Nr:');
NumOfUsers1 = input('\nEnter the value for total number of users :');
VarianceSq1 = input('\nEnter the value for the variance square for the complex gaussian zero mean random variables :');
SNRindB1 = input('\nEnter the value for SNR in dB :');

% using SUBOPTIMAL ALGORITHMS to generate required plots.


% plotting SUMCAPACITY versus NUMBER OF USERS plot.
user1 = zeros(1,20);
SumCapacityArr1 = zeros(1,20);
SumCapacityArr2 = zeros(1,20);
for K=1:20
    user1(K)=K;
    [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB1);
    [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2,DataStreams2 ] = SuboptimalAlgorithm2( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB1);
    SumCapacityArr1(K) = SumCapacity1;
    SumCapacityArr2(K) = SumCapacity2;
end

figure(1)
plot(user1,SumCapacityArr1);
title('sumcapacity vs number of users for SA1');
xlabel('number of users');
ylabel('sum capacity');

figure(2)
plot(user1,SumCapacityArr2);
title('sumcapacity vs number of users for SA2');
xlabel('number of users');
ylabel('sum capacity');



% plotting SUMCAPACITY versus SNRdB plot.

K=1;
snr1 = zeros(1,35);
SumCapacityArr1 = zeros(1,35);
SumCapacityArr2 = zeros(1,35);
for SNRdB1 = -5:30
    
    snr1(K) = SNRdB1;
    
    [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,NumOfUsers1,SNRdB1);
    [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2 ,DataStreams2 ] = SuboptimalAlgorithm2( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,NumOfUsers1,SNRdB1);
    
    SumCapacityArr1(K) = SumCapacity1;
    SumCapacityArr2(K) = SumCapacity2;
    
    K=K+1;
end    

figure(3)
plot(snr1, SumCapacityArr1);
title('sumcapacity vs SNRdB for SA1');
xlabel('SNRdB');
ylabel('sum capacity');


figure(4)
plot(snr1, SumCapacityArr2);
title('sumcapacity vs SNRdB for SA2');
xlabel('SNRdB');
ylabel('sum capacity');
