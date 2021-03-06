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

% plotting SUMCAPACITY versus SNRdB plot.

snr1 = zeros(1,35);
SumCapacityArr1 = zeros(1,36);
SumCapacityArr2 = zeros(1,36);
for iteration = 1:100
K=1;
for SNRdB1 = -5:30
    
    snr1(K) = SNRdB1;
    
    [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,NumOfUsers1,SNRdB1);
    [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2 ,DataStreams2 ] = SuboptimalAlgorithm2( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,NumOfUsers1,SNRdB1);
    
    SumCapacityArr1(K) = SumCapacityArr1(K) + SumCapacity1;
    SumCapacityArr2(K) = SumCapacityArr2(K) + SumCapacity2;
    
    K=K+1;
end    
end
SumCapacityArr1 = SumCapacityArr1/100;
SumCapacityArr2 = SumCapacityArr2/100;
figure(2)
plot(snr1, SumCapacityArr1,'b--*')
hold on
plot(snr1, SumCapacityArr2,'r--*')
title('sumcapacity vs SNRdB');
xlabel('SNRdB');
ylabel('sum capacity');
legend('SA1','SA2','location','northwest')
hold off;
%--------------------------END OF PROGRAME---------------------------------