%AUTHOR - Justin
%Iteratively computes the bpm of a track, one window at a time

close all; %close all plots

%%%%%%CONFIG SETTINGS%%%%%%%%
%window_period = 4; %choose duration in seconds
%mving_ave_samples = 15;
v_metaparams_mpa
window_offset = 0; %choose window offset

%List of tracknames
%track_name = 'fortroad_lost.wav'; %(Actual ~85)
%track_name = 'heybrother_avicii.wav'; %(Actual ~125)
%track_name = 'thefatrat_timelapse.wav'; %(Actual ~127)
%track_name = 'belwoorf_nostalgia.wav'; %(Actual is either ~168 or 84)
%track_name = 'djfresh_golddust.wav'; %(Actual ~73 or 145)
%track_name = '180bpmidealwithnoise.wav';


%load track
[track_samples, sampling_f, sample_times] = f_load_track(track_name);
window_length = window_period*sampling_f;

%determine number of windows
num_windows = f_num_windows(track_samples, window_length);

%perform iterative computation
bpm_values = [];
window_number = 1;
mvpwr_acp = zeros(window_length+1, 1);
while(window_number < num_windows)
    
    %calculate the mvpwr_acp and then accumulate result
    mv_pwr_i = f_mv_pwr(f_get_window(track_samples, window_number, window_length), mving_ave_samples);
    mvpwr_acp_i = f_acp_operation(mv_pwr_i);
    mvpwr_acp = mvpwr_acp + mvpwr_acp_i;
    
    %using the accumulated mvpwr_acp determine the bpm
    [peak_values, peak_times] = f_peak_finder_acfwind(mvpwr_acp, sampling_f);
    bpm = f_peaks_to_bpm(peak_values, peak_times);
    bpm_values = [bpm_values, bpm];
    
    window_number = window_number + 1;
end

disp("BPM: " + bpm)

%plot
figure();
plot(bpm_values);
xlabel("Accumulative number of windows used");
ylabel("BPM Estimate");


