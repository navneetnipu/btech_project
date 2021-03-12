x=1:0.1:10;
y=sin(x);
figure(1)
plot(x,y,'r--*')
figure(2)
plot(x,y,'b--o')

for snr= [0 0.1 0.2 0.3 0.4 0.5]
    disp(snr);
end