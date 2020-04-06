% MOVING AVERAGE POWER METHOD
close all; %Close all plots

%Import sound data
%track_name = 'fortroad_lost.wav';
%track_name = 'heybrother_avicii.wav';
track_name = 'Avicii - Hey Brother.wav';
%track_name = 'fortroad_lost 3.wav';
[x fs]=audioread(track_name);

%Create a time index
t=0:1/fs:(length(x)-1)/fs;

%'Trim' size of file down to sec seconds duration
duration = 5; %Choose duration in seconds
start_time = 33; %Choose start time in seconds

finish_time = start_time + duration;
trimi = find(start_time-1/fs <= t & t <= start_time+1/fs);
trimf = find(finish_time-1/fs <= t & t <= finish_time+1/fs);
xshort=x(trimi:trimf);
tshort = t(trimi:trimf);

figure
plot(tshort,xshort)
xlim([start_time finish_time])
title("Short Section of Sound Data");

%Play sound
soundsc(xshort,fs)


%Moving Average Power
pshort = movmean(xshort.^2, 5);

figure
plot(tshort,pshort)
title("Plot of moving average power")
xlabel('Time (s)')

%Plot moving ave pwr and sound on same axes
figure
plot(tshort,xshort)
hold on
plot(tshort,pshort)
hold off
title("Plot of sound data and moving average power")
xlabel('Time (s)')
legend('sound data', 'average power')

%Perform an auto-correlation on the moving ave power
acpshort = xcorr(pshort);
%Create a time axis
tACF=0:1/fs:(length(acpshort)-1)/fs;

%Plot the autocorrelation of the moving ave pwr
figure
plot(tACF,acpshort)
title("Plot of autocorrelated moving average power")
xlabel('Time (s)')

% CALCULATE BPM
% Set guidelines on finding the peaks
minPeakDistance=0.25;
minPeakHeight=5;
% Find the peaks and locations
[pks,times] = findpeaks(acpshort,fs,'MinPeakDistance',minPeakDistance,...
    'MinPeakHeight',minPeakHeight);
% Plot points on AC function
findpeaks(acpshort,fs,'MinPeakDistance',minPeakDistance,...
    'MinPeakHeight',minPeakHeight); 

timeDifference=mean(diff(times)); % Get the time difference between the peaks
BPM=(1/timeDifference)*60;
disp("BPM calculated -> " + BPM)

disp("Short sound clip samples -> " + length(pshort))
disp("Auto correlation samples -> " + length(acpshort)) %Is 2N-1


%Observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fortroad - Lost
%189300 - 158200 -> 31100 %Difference between two adjacent peaks in the auto
%correlation of moving pwr -> 85.1 bpm (Actual ~85)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Avicii - Hey Brother
%(241700 - 199300)/2 -> 21200 -> 124.8 bpm (Actual ~125)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Belwoorf - Nostalgia first 5 seconds
%126100 - 110400 -> 15700 -> 168.5 bpm (Actual is either ~168 or 84)


return


% Frequency Domain

% Frequency plots
n=-(length(acpshort)-1)/2:(length(acpshort)-1)/2;
f=(fs/length(acpshort))*n;

FTP=fftshift(fft(acpshort));
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

%return

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
