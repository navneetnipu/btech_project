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

% plotting SUMCAPACITY versus NUMBER OF USERS plot.

user2 = zeros(1,21);
SumCapacityArr1 = zeros(1,21);
SumCapacityArr2 = zeros(1,21);
for SNRindB2=[0 10 20 30]
    for iteration = 1:1000
        for K=1:21
            user2(K)=K-1;
            [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB2);
            [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2,DataStreams2 ] = SuboptimalAlgorithm2Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB2);
            SumCapacityArr1(K) = SumCapacityArr1(K)+ SumCapacity1;
            SumCapacityArr2(K) = SumCapacityArr2(K) + SumCapacity2;
        end
    end
    SumCapacityArr1 = SumCapacityArr1/1000;
    SumCapacityArr2 = SumCapacityArr2/1000;
    figure(1)
    plot(user2,SumCapacityArr1,'b--*','linewidth',2)
    hold on
    plot(user2,SumCapacityArr2,'r--*','linewidth',2)
    title('sumcapacity vs number of users');
    xlabel('number of users');
    ylabel('sum capacity');
    legend('SA1','SA2','location','northwest')
    hold on
    grid on
end
hold off;

% plotting SUMCAPACITY versus SNRdB plot.

snr1 = zeros(1,41);
SumCapacityArr1 = zeros(1,41);
SumCapacityArr2 = zeros(1,41);
for iteration = 1:1000
    K=1;
    for SNRdB1 = -10:30
        
        snr1(K) = SNRdB1;
        
        [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,NumOfUsers1,SNRdB1);
        [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2 ,DataStreams2 ] = SuboptimalAlgorithm2Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,NumOfUsers1,SNRdB1);
        
        SumCapacityArr1(K) = SumCapacityArr1(K) + SumCapacity1;
        SumCapacityArr2(K) = SumCapacityArr2(K) + SumCapacity2;
        
        K=K+1;
    end
end
SumCapacityArr1 = SumCapacityArr1/1000;
SumCapacityArr2 = SumCapacityArr2/1000;
figure(2)
plot(snr1, SumCapacityArr1,'b--*','linewidth',2)
hold on
plot(snr1, SumCapacityArr2,'r--*','linewidth',2)
title('sumcapacity vs SNRdB');
xlabel('SNRdB');
ylabel('sum capacity');
legend('SA1','SA2','location','northwest')
grid on
hold off;
%--------------------------END OF PROGRAME---------------------------------