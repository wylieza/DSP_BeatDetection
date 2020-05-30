%AUTHOR - Justin
%Designed to estimate the BPM from the result of the f_peak_finder_acfwind
%function
%Takes: [[peaks], [peak rel. times]]
%returns: [bpm]

function bpm = f_peaks_to_bpm(peak_values, peak_times)
%debug flag
debug = 0;

if(isempty(peak_values))
    bpm = 0;    
else
    diffs = round(diff(peak_times), 3); %Rounding corrects for slight deviations in time
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