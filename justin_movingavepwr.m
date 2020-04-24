%Stats on the go section%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%djfresh - golddust (Actual ~73 or 145)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%thefatrat - timelapse (Actual ~127)

% MOVING AVERAGE POWER METHOD
close all; %Close all plots

%Import sound data
%track_name = 'fortroad_lost.wav';
track_name = 'heybrother_avicii.wav';
%track_name = 'thefatrat_timelapse.wav';
%track_name = 'belwoorf_nostalgia.wav';
%track_name = 'djfresh_golddust.wav';

[x, fs]=audioread(track_name);

%Create a time index
t=0:1/fs:(length(x)-1)/fs;

%%%%%%CONFIG%%%%%%%%
%'Trim' size of file down to sec seconds duration
duration = 5; %Choose duration in seconds
start_time = 40; %Choose start time in seconds
min_bpm = 40;
max_bpm = 200;

%%%%%%%%%%%%%%%%%%%%

finnish_time = start_time + duration;
trimi = find(start_time-1/fs <= t & t <= start_time+1/fs);
trimf = find(finnish_time-1/fs <= t & t <= finnish_time+1/fs);
xshort=x(trimi:trimf);
tshort = t(trimi:trimf);

%display short section of sound data
%figure
%plot(tshort,xshort)
%xlim([start_time finnish_time])
%title("Short Section of Sound Data");

%Play sound
%soundsc(xshort,fs)


%Moving Average Power
pshort = movmean(xshort.^2, 150);

%moving average power plot
%figure
%plot(tshort,pshort)
%title("Plot of moving average power")
%xlabel('Time (s)')

%Plot moving ave pwr and sound on same axies
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

%Remove just a bit less than the second half of acpshort because it is redundant data
acpshort = acpshort(1:floor(length(acpshort)/2+200)); %Removal constant should ideally be calculated...

%Create a reletive time axis
tacpshort = (0:1/fs:(length(acpshort)-1)/fs);


%generate a best fit line for the acp
if(0)
index = 1;
width = 5*44100; %in samples
offset = 0; %offset from the current curve
while((index + width) < length(acpshort))
    pfit_coeff = polyfit(1:width, acpshort(index:(index+width-1)), 1);
    pfit_line(index:(index+width-1)) = arrayfun(@(x) x + offset, linspace(0, width - 1, width).*pfit_coeff(1));
    offset = pfit_line(index+width-1);
    index = index + width;
end
%Deal with the last 'left over' bit of samples
width = mod(length(acpshort),width);
pfit_coeff = polyfit(1:width, acpshort(index:(index+width-1)), 1);
pfit_line(index:(index+width-1)) = arrayfun(@(x) x + offset, linspace(0, width - 1, width).*pfit_coeff(1));

%Plot the autocorrelation of the moving ave pwr with the best fit
figure
plot(tacpshort, acpshort);
hold on;
plot(tacpshort, pfit_line);
hold off;
title("Plot of autocorrelated moving average power")
xlabel('Time (s)')
end




% CALCULATE BPM
% Set guidelines on finding the peaks
minPeakDistance=60/max_bpm;
min_peak_prom = 15;



%Plot the autocorrelation of the moving ave pwr WITH TIME
%figure();
%plot(tacpshort, acpshort)
%title("Plot of autocorrelated moving average power")
%xlabel('Time Instance (s)')

% Find the peaks and locations
[pks,times] = findpeaks(acpshort,fs,'MinPeakDistance',minPeakDistance,...
    'MinPeakProminence',min_peak_prom);

%remove bad peaks
i = 2;
while(i < length(pks)+1)
    if(pks(i-1) > pks(i))
        pks(i) = [];
        times(i) = [];
    else
    i = i + 1;
    end
end

%plot the corrected peak markers
figure();
plot(tacpshort, acpshort)
hold on;
plot(times, pks, 'x');
hold off;
title("Plot of autocorrelated moving average power")
xlabel('Time Instance (s)')



% Plot points on AC function automatically
%figure
%findpeaks(acpshort,fs,'MinPeakDistance',minPeakDistance,...
%    'MinPeakProminence',min_peak_prom);
%title("Plot of findpeaks result")
%xlabel('Time Instance (s)')



diffs = round(diff(times), 3)
display("Median is:" + median(diff(times)));
timeDifference=median(diffs); % Get the time difference between the peaks
BPM=(1/timeDifference)*60;
disp("BPM calculated -> " + BPM)


disp("Short sound clip samples -> " + length(pshort))
disp("Auto correlation samples -> " + length(acpshort)) %Is 2N-1

if(0)




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
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Observations
%function bpm = get_bpm(indexi, indexf)
%    bpm = 60/((indexf - indexi)/44100);
%end


