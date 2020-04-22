%%%REQUIREMENTS%%%
%acp_window.m
%acp_calcbpm.m

% MOVING AVERAGE POWER METHOD
close all; %Close all plots

%List of tracknames
%track_name = 'fortroad_lost.wav'; %(Actual ~85)
%track_name = 'heybrother_avicii.wav'; %(Actual ~125)
%track_name = 'thefatrat_timelapse.wav'; %(Actual ~127)
%track_name = 'belwoorf_nostalgia.wav'; %(Actual is either ~168 or 84)
track_name = 'djfresh_golddust.wav'; %(Actual ~73 or 145)

%%%%%%CONFIG SETTINGS%%%%%%%%
%'Trim' size of file down to sec seconds duration
duration = 5; %Choose duration in seconds
start_time = 0; %Choose start time in seconds

%min_bpm = 40; %UNUSED
max_bpm = 200;
fs = 44100;

%Typical usage
%[acp, rtime] = acp_window(track_name, duration, start_time);
%bpm = acp_calcbpm(acp, fs, max_bpm);
%disp(bpm)
%figure();
%plot(rtime, acp);

[acp, rtime] = acp_window(track_name, duration, start_time); %Get a time axis and first window
start_time = 0;
loop_number = 1;
max_loops = floor(track_length(track_name)/duration);

max_loops = 3;

while(loop_number < max_loops)
    start_time = loop_number*duration;
    
    [acp_i, ~] = acp_window(track_name, duration, start_time);
    
    acp = acp + acp_i;
    
    loop_number = loop_number + 1;
end

bpm = acp_calcbpm(acp, fs, max_bpm);
disp("BPM: " + bpm)


%Functions
function tk_len = track_length(track_name)
    
    [x, fs]=audioread(track_name);
    tk_len = length(x)/fs;

end
