%Calculates the most likely BPM from a given window function

function bpm = acp_calcbpm(acpshort, fs, max_bpm)
debug = 1;

%Set guidelines on finding the peaks
minPeakDistance=60/max_bpm;
min_peak_prom = 15;

%Find the peaks and locations
[pks,times] = findpeaks(acpshort,fs,'MinPeakDistance',minPeakDistance,...
    'MinPeakProminence',min_peak_prom);

%Remove 'bad' peaks
i = 2;
while(i < length(pks)+1)
    if(pks(i-1) > pks(i))
        pks(i) = [];
        times(i) = [];
    else
    i = i + 1;
    end
end

%Last peak MUST be max value
[mv, mi] = max(acpshort)
if(~isempty(pks))
    pks(length(pks)) = mv;
    times(length(times)) = mi/fs;
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

if(isempty(pks))
    bpm = 0;    
else
    diffs = round(diff(times), 3); %Rounding corrects for slight deviations in time
    mode_diff = mode(diffs); % Get the time difference between the peaks
    bpm=(1/mode_diff)*60;
end
    

if(debug)
    disp("Peak time differences:");
    if (~isempty(pks))
        diffs
        display("Mode is:" + mode_diff);
    end
    disp("BPM calculated -> " + bpm);
end


end