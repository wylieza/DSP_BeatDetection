% AUTHOR - Kate (adapted from Justin's movingavepwr.m)
% Calculates the BPM of a song and finds the beat locations

close all; %Close all plots

%Import sound data
%track_name = 'fortroad_lost.wav';
track_name = 'heybrother_avicii.wav';
%track_name = 'thefatrat_timelapse.wav';
%track_name = 'belwoorf_nostalgia.wav';
%track_name = 'djfresh_golddust.wav';
%track_name ='180bpmidealwithnoise.wav';

% Meta-parameter - set the number of samples for the test
num_samples = 10;

[x, fs]=audioread(track_name);

%Create a time index
t=0:1/fs:(length(x)-1)/fs;

% Just use part of the song for now
%duration = 5; %Choose duration in seconds
%duration = 20;
duration = 185; % Timelapse
% duration = 78; % Lost
% duration = 183; % Golddust
% duration = 240; % Nostalgia
% duration = 263; % Hey Brother
% duration = 150; % 180 BPM
start_time = 0; %Choose start time in seconds
min_bpm = 40;
max_bpm = 200;


finish_time = start_time + duration;
trimi = find(start_time-1/fs <= t & t <= start_time+1/fs);
trimf = find(finish_time-1/fs <= t & t <= finish_time+1/fs);
xshort=x(trimi:trimf);
tshort = t(trimi:trimf);

%Play sound
%soundsc(xshort,fs)


%Moving Average Power
% Test with different numbers of samples per calcution (to change LPF effect)
%pshort = movmean(xshort.^2, 150);
%pshort = movmean(xshort.^2, 1000);
pshort = movmean(xshort.^2, 10);

%Plot moving ave power and sound on same axes
figure
plot(tshort,xshort)
hold on
plot(tshort,pshort)
hold off
title("Plot of sound data and moving average power")
xlabel('Time (s)')
legend('sound data', 'average power')


% FIND PEAKS (which might be beats)
% Set guidelines on finding the peaks
minPeakDistance=60/max_bpm;
min_peak_prom = 15; % Not used

% Find the peaks and locations
% Note - when peak prominence is used, no peaks are detected (even with a 
% low value)
[pks,times] = findpeaks(pshort,fs,'MinPeakDistance',minPeakDistance);
%[pks,times] = findpeaks(pshort,fs,'MinPeakDistance',minPeakDistance,...
%    'MinPeakProminence',min_peak_prom);

%Plot the peak markers
figure();
plot(tshort, pshort)
hold on;
plot(times, pks, 'x');
hold off;
title("Plot of moving average power with peaks indicated")
xlabel('Time (s)')

% Calculate the BPM
diffs = round(diff(times), 3); % Round off
timeDifference=mean(diffs); % Get the time difference between the peaks
BPM=(1/timeDifference)*60; % BPM calculation
disp("BPM calculated -> " + BPM)


disp("Beat locations are stored in the array called 'times'")





