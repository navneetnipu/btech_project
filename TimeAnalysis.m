clc;
clear all;
close all;

% Taking user input.

disp('Enter the data for the mu mimo single downlink system-----');
NumOfTransmitAntennas1 = input('\nEnter the values for number of transmit antennas Nt:');
NumOfReceiveAntennasPerUser1 = input('\nnumber of receive antennas per user Nr:');
VarianceSq1 = input('\nEnter the value for the variance square for the complex gaussian zero mean random variables :');

% plotting SUMCAPACITY versus NUMBER OF USERS plot.

user2 = 0;
t1 = zeros(100,25);
t2 = zeros(100,25);
SumCapacityArr1 = 0;
SumCapacityArr2 = 0;
x = 1;
for SNRindB2=[0 10 20 30]
       for K=1:25
           for iteration = 1:1000
            tic
            [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB2);
            t1(iteration,K)= toc;
            tic
            [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2,DataStreams2 ] = SuboptimalAlgorithm2Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB2);
            t2(iteration,K)= toc;
           end     
       end
       figure(x)
       timeSA1 = sum(t1,1)/1000;
       timeSA2 = sum(t2,1)/1000;
       plot(1:25,timeSA1,'b-*','linewidth',2)
       hold on
       plot(1:25,timeSA2,'r-*','linewidth',2)
       hold off;
       title('TIME COMPLEXITY vs NUMBER OF USERS');
       xlabel('NUMBER OF USERS');
       ylabel('TIME COMPLEXITY');
       grid on;
       legend('SA1','SA2','location','northwest')
       x = x+1;
end
for K = [5 10 15 20]
       for SNRindB2= 0:30
           for iteration = 1:1000
            tic
            [ SumCapacity1,SelectedReceiveAntenna1,SelectedUser1,DataStreams1 ] = SuboptimalAlgorithm1Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB2);
            t1(iteration,SNRindB2+1)= toc;
            tic
            [ SumCapacity2,SelectedReceiveAntenna2,SelectedUser2,DataStreams2 ] = SuboptimalAlgorithm2Final( NumOfTransmitAntennas1,NumOfReceiveAntennasPerUser1, VarianceSq1,K,SNRindB2);
            t2(iteration,SNRindB2+1)= toc;
           end     
       end
       figure(x)
       timeSA1 = sum(t1,1)/1000;
       timeSA2 = sum(t2,1)/1000;
       plot(0:30,timeSA1,'b-*','linewidth',2)
       hold on
       plot(0:30,timeSA2,'r-*','linewidth',2)
       hold off;
       title('TIME COMPLEXITY vs SNR in dB');
       xlabel('SNR in dB');
       ylabel('TIME COMPLEXITY');
       grid on
       legend('SA1','SA2','location','northwest')
       x = x+1;
end