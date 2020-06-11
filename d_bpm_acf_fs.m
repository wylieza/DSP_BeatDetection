%AUTHOR - Justin
%Computes the bpm of a track using a window of specified size

close all; %close all plots

%legend_tags = ["Lost", 'Hey Brother', 'Timelapse', 'Nostalgia', 'Gold Dust', '180 BPM Ideal'];
%track_names = ["fortroad_lost.wav", 'heybrother_avicii.wav', 'thefatrat_timelapse.wav', 'belwoorf_nostalgia.wav', 'djfresh_golddust.wav', '180bpmidealwithnoise.wav'];
%track_bpm = [85.21, 125.2, 127.2, 84.04, 72.67, 180.4];
%moving_ave_samples_arr = [1, 5, 10, 15, 20, 50, 100, 500, 1000];
%window_periods = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];

%error_vs_windownum();
%error_vs_window_period;
error_vs_mas;

function error_vs_mas()
v_metaparams_mpa

%plot
figure();
hold on;
xlabel("Number of Moving Average Samples");
ylabel("Mean BPM Error (%)");
xticks(1:length(moving_ave_samples_arr));
xticklabels(moving_ave_samples_arr);

for index = 1:length(track_names)
    mean_accuracy_arr = [];
    for mas = moving_ave_samples_arr
        track_name = track_names(index);
        window_period = window_periods(5);
        accuracy_arr = error(track_bpm(index), f_bpm_acf(track_name, window_period, mas));
        mean_accuracy_arr = [mean_accuracy_arr, sum(accuracy_arr)/length(accuracy_arr)];
    end
    plot(mean_accuracy_arr, '-O');
end

hold off;
legend(legend_tags);

end

function error_vs_window_period()
v_metaparams_mpa

%plot
figure();
hold on;
xlabel("Window Period");
ylabel("Mean BPM Error (%)");
xticks(window_periods);

for index = 1:length(track_names)
    mean_accuracy_arr = [];
    for window_period = window_periods
        track_name = track_names(index);
        mving_ave_samples = moving_ave_samples_arr(4);
        accuracy_arr = error(track_bpm(index), f_bpm_acf(track_name, window_period, mving_ave_samples));
        mean_accuracy_arr = [mean_accuracy_arr, sum(accuracy_arr)/length(accuracy_arr)];
    end
    plot(window_periods, mean_accuracy_arr, '-O');
end

hold off;
legend(legend_tags);

end

function error_vs_windownum()
v_metaparams_mpa

%plot
figure();
hold on;
xlabel("Window Number");
ylabel("BPM Error (%)");

for index = 1:length(track_names)
    track_name = track_names(index);
    window_period = window_periods(5);
    mving_ave_samples = moving_ave_samples_arr(4);
    
    plot(error(track_bpm(index), f_bpm_acf(track_name, window_period, mving_ave_samples)), '-O');
end

hold off;
legend(legend_tags);

end



function [results] = accuracy(actual, estimates)

    results = zeros(length(estimates), 1);
    for i = 1:length(estimates)
        msd = actual - estimates(i);
        results(i) = msd;
    end
end

function [results] = error(actual, estimates)
    results = zeros(length(estimates), 1);
    for i = 1:length(estimates)
        difference = abs(actual - estimates(i));
        
        results(i) = difference/actual;
        
        if (results(i) > 0.9 && estimates(i) > 0.9*actual) %Assume it was aiming for double time BPM
            results(i) = abs(1 - results(i));
        end
        
        results(i) = results(i)*100;
        
    end   
end





function [bpm_values] = f_bpm_acf(track_name, window_period, mving_ave_samples)
%load track
[track_samples, sampling_f, sample_times] = f_load_track(track_name);
window_length = window_period*sampling_f;

%determine number of windows
num_windows = f_num_windows(track_samples, window_length);

%perform iterative computation
bpm_values = [];
window_number = 1;
while(window_number < num_windows)
    
    %calculate the mvpwr_acp and then store the result
    mv_pwr_i = f_mv_pwr(f_get_window(track_samples, window_number, window_length), mving_ave_samples);
    mvpwr_acp_i = f_acp_operation(mv_pwr_i);

    
    %using the mvpwr_acp_i determine the bpm
    [peak_values, peak_times] = f_peak_finder_acfwind(mvpwr_acp_i, sampling_f);
    bpm = f_peaks_to_bpm(peak_values, peak_times);
    bpm_values = [bpm_values, bpm];
    
    window_number = window_number + 1;
end

end


