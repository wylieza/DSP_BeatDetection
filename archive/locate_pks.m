%Peak Finder

function [pks, times] = locate_pks(acpshort, fs, max_bpm)
debug = 1;

%Set guidelines on finding the peaks
minPeakDistance=60/max_bpm;
min_peak_prom = 15;

%Find the peaks and locations
[pks,times] = findpeaks(acpshort,fs,'MinPeakDistance',minPeakDistance,...
    'MinPeakProminence',min_peak_prom);

%Last peak MUST be max value (For some reason, the findpeaks doesn't know this)
[mv, mi] = max(acpshort)
if(~isempty(pks))
    pks(length(pks)) = mv;
    times(length(times)) = mi/fs;
end

%Remove 'bad' peaks (If you correlate less than a previous 'peak' you are unlikely a beat...)
i = 2;
while(i < length(pks)+1)
    if(pks(i-1) > pks(i))
        pks(i) = [];
        times(i) = [];
    else
    i = i + 1;
    end
end

%Plot the corrected peak markers
if(debug)
    figure();
    plot(acpshort)
    hold on;
    plot(times*fs, pks, 'x');
    hold off;
    title("Plot of autocorrelated moving average power")
    xlabel('Time Instance (s)')
end


end