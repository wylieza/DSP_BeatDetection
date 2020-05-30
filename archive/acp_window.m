%For a given track, computes the ACF of the power for a chosen short duration

function [acp_wind, tshort] = acp_window(track_name, duration, start_time)

%Read Track
[x, fs]=audioread(track_name);

%Create a time index
t=0:1/fs:(length(x)-1)/fs;

%Shorten the sample
%Determine start index and number of points
start_index = start_time*fs + 1;
end_index = start_index + duration*fs + 1;

%Cut out that short section
xshort=x(start_index:end_index);
tshort = t(start_index:end_index);

%Moving Average of Signal Power for short
pshort = movmean(xshort.^2, 15);

%Auto-correlation of the moving ave power
acpshort = xcorr(pshort);

%Remove the second half, but including the highest point (anchor)
[~, maxi] = max(acpshort);
acp_wind = acpshort(1:maxi);

end