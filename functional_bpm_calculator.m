%%%REQUIREMENTS%%%
%acp_window.m
%acp_calcbpm.m

% MOVING AVERAGE POWER METHOD
close all; %Close all plots

%List of tracknames
%track_name = 'fortroad_lost.wav'; %(Actual ~85)
track_name = 'heybrother_avicii.wav'; %(Actual ~125)
%track_name = 'thefatrat_timelapse.wav'; %(Actual ~127)
%track_name = 'belwoorf_nostalgia.wav'; %(Actual is either ~168 or 84)
%track_name = 'djfresh_golddust.wav'; %(Actual ~73 or 145)

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
acp = acp(5:length(acp)); %Temp fix
rtime = rtime(1:length(acp)); %Temp fix

while(start_time + 2*duration < track_length(track_name))
    start_time = start_time + duration;
    
    [acp_i, ~] = acp_window(track_name, duration, start_time);
    
    acp_i = acp_i(length(acp_i) - length(acp)+1:length(acp_i));
    %length(acp)
    %length(acp_i)
    
    acp = acp + acp_i;
    
end

bpm = acp_calcbpm(acp, fs, max_bpm);
disp("BPM: " + bpm)


%Functions
function tk_len = track_length(track_name)
    
    [x, fs]=audioread(track_name);
    tk_len = length(x)/fs;

end
