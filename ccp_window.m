% For a given track, computes the CCF of the power for a window (chosen short duration) 
% with the previous window 

% NOTE the start time must be >= duration
function [ccp_wind, t1short] = ccp_window(track_name, duration, start_time)

if start_time < duration
    return
end

%Read Track
[x, fs]=audioread(track_name);

%Create a time index
t=0:1/fs:(length(x)-1)/fs;

% Create the window
finish_time = start_time + duration;
trimi = find(start_time-1/fs <= t & t <= start_time+1/fs);
trimf = find(finish_time-1/fs <= t & t <= finish_time+1/fs);
x1short=x(trimi:trimf);
t1short = t(trimi:trimf);

% Create the previous window
finish_time = start_time;
start_time = start_time - duration;
trimi = find(start_time-1/fs <= t & t <= start_time+1/fs);
trimf = find(finish_time-1/fs <= t & t <= finish_time+1/fs);
x2short=x(trimi:trimf);
%t2short = t(trimi:trimf);

%Moving Average of Signal Power for windows
p1short = movmean(x1short.^2, 15);
p2short = movmean(x2short.^2, 15);

%Cross-correlation of the moving ave power
ccpshort = xcorr(p1short, p2short);

%Remove the second half, but including the highest point (anchor)
[~, maxi] = max(ccpshort);
ccp_wind = ccpshort(1:maxi);

% Potentially also work out the BPM for the window in this function 
% and return it 

end