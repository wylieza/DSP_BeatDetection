%AUTHOR - Justin
%Iteratively computes the bpm of a track, one window at a time

close all; %close all plots

%%%%%%CONFIG SETTINGS%%%%%%%%
window_duration = 6; %choose duration in seconds
window_offset = 0; %choose window offset

%list of tracknames
track_name = 'fortroad_lost.wav'; %(Actual ~85)


%load track
[track_samples, sampling_f, sample_times] = f_load_track(track_name);
window_length = window_duration*sampling_f;

%determine number of windows
num_windows = f_num_windows(track_samples, window_length);

%[acp, rtime] = acp_window(track_name, duration, start_time); %Get a time axis and first window
%start_time = 0;
%loop_number = 1;
%max_loops = floor(track_length(track_name)/duration);

%max_loops = 3;

window_number = 1;
mvpwr_acp = []
while(window_number < num_windows)
    
    mvpwr_acp_i = f_mvpwr_acp(f_get_window(track_samples, window_number, window_length));
    
    mvpwr_acp = mvpwr_acp + mvpwr_acp_i;
    
    window_number = window_number + 1;
end

[peak_values, peak_times] = f_peak_finder_acfwind(mvpwr_acp, sampling_f);
bpm = f_peaks_to_bpm(peak_values, peak_times);

disp("BPM: " + bpm)

%Functions
function tk_len = track_length(track_name)
    
    [x, sampling_f]=audioread(track_name);
    tk_len = length(x)/sampling_f;

end