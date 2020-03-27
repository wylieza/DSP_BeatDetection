% MOVING AVERAGE POWER METHOD

% Sound Data
[x fs]=audioread('Avicii - Hey Brother.wav');
% 'Trim' size of file
x=x(100:1000000);

% Play sound
%soundsc(y,fs)

% Time axis
t=0:1/fs:(length(x)-1)/fs;
figure
plot(t,x)
%plot(x)
title("Plot of a short period of the original sound data")


% Moving Average Power Calculations
p=zeros(1,length(x));
% Set first value to just be the power of the first sample
% (as x[n-1] is undefined)
p(1)= (x(1))^2;

% Work out the moving average using 5 samples for each calculation
p(2)= 1/2*((x(1))^2+(x(2))^2);
for i=3:(length(x)-2)
    p(i)=1/5*((x(i-2))^2+(x(i-1))^2+(x(i))^2+(x(i+1))^2+(x(i+2))^2);
end

figure
plot(t,p)
title("Plot of moving average power")
xlabel('Time (s)')

% Plot the sound data and average power on top of each other
figure
plot(t,x)
hold on
plot(t,p)
hold off
title("Plot of sound data and moving average power")
xlabel('Time (s)')
legend('sound data', 'average power')

% Frequency Domain

% Frequency plots
n=-(length(p)-1)/2:(length(p)-1)/2;
f=(fs/length(p))*n;

FTP=fftshift(fft(p));
% Remove value at f=0
FTP(f==0)=0;
figure
%subplot(2,1,1)
plot(f,abs(FTP))
title("Frequency response of moving average power")
xlabel("Frequency (Hz)")
ylabel("Magnitude")
%subplot(2,1,2)
%plot(f,angle(fftshift(fft(y))))
%xlabel("Frequency (Hz)")
%ylabel("Phase")

% Envelope Extraction

% Using Hilbert function
%https://www.mathworks.com/help/signal/ug/envelope-extraction-using-the-analytic-signal.html
pH = hilbert(p);
pEnv = abs(pH);
plot_param = {'Color', [0.6 0.1 0.2],'Linewidth',2}; 

%figure
%plot(t,p)
%hold on
figure
plot(t,pEnv,plot_param{:})
%hold off
%xlim([0 0.04])
title('Hilbert Envelope of moving average power')

% Frequency plots
n=-(length(p)-1)/2:(length(p)-1)/2;
f=(fs/length(p))*n;

FTPEnv=fftshift(fft(pEnv));
% Remove value at f=0
FTPEnv(f==0)=0;
figure
%subplot(2,1,1)
plot(f,abs(FTPEnv))
title("Frequency response of moving average power")
xlabel("Frequency (Hz)")
ylabel("Magnitude")


