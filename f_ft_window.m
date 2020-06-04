% AUTHOR - Kate
% Finds the Fourier Transform of a window specified by the starting time
% and duration

% ft_wind -> Fourier Transform of window (positive frequencies only)
% f -> corresponding frequency axis
function [ft_wind, f] = f_ft_window(track_name, duration, start_time, ...
    min_bpm, max_bpm, num_samples)

%Read Track
[x, fs]=audioread(track_name);

%Create a time index
t=0:1/fs:(length(x)-1)/fs;

%Shorten the sample
finish_time = start_time + duration;
trimi = find(start_time-1/fs <= t & t <= start_time+1/fs);
trimf = find(finish_time-1/fs <= t & t <= finish_time+1/fs);
xshort=x(trimi:trimf);

% Moving Average of Signal Power for short
pshort = movmean(xshort.^2, num_samples);

% FOURIER TRANSFORM

% Frequency axis
n=-(length(pshort)-1)/2:(length(pshort)-1)/2;
f=(fs/length(pshort))*n;

% Fourier Transform of the moving ave power
ftpshort=fftshift(fft(pshort));

% Remove first half (negative frequencies)
ft_wind= ftpshort(f>=0);
f=f(f>=0);

% Constraints
% A song will typically have a tempo between 40 bpm (/min_bpm)
% and 200 bpm (/max_bpm)
ft_wind(f<=(min_bpm/60))=0;
ft_wind(f>=(max_bpm/60))=0;


end
