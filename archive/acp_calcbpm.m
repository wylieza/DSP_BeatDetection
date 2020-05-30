%Calculates the most likely BPM from a given window function

%%%REQUIREMENTS%%%
%locate_pks.m

function bpm = acp_calcbpm(acpshort, fs, max_bpm)

debug = 1;

[pks, times] = locate_pks(acpshort, fs, max_bpm);

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