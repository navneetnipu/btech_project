clc;
close all;
clear all;
channelMatrix=sqrt(1/2)*randn(3,3)+sqrt(1/2)*randn(3,3)*i;
for i = 1:3
    disp(vertcat(channelMatrix(i,:),channelMatrix(1,:)));
end