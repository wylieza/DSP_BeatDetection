% Calculate the BPM of a song using frequency domain analysis
% Requires ft_window.m

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

min_bpm = 40; 
max_bpm = 200;
fs = 44100;

% START: Typical usage
%[ft_wind, f] = ft_window(track_name, duration, start_time, min_bpm, max_bpm);
%figure();
%plot(f, abs(ft_wind))
%xlim([0 10])
%title("Frequency response of moving average power")
%xlabel("Frequency (Hz)")
%ylabel("Magnitude")
% Calculate BPM
%Find dominant frequency
%maxPeak= max(abs(ft_wind));
%dominantFreq=f(abs(ft_wind)==maxPeak);
%BPM = dominantFreq*60;
% END: Typical usage

% Get first window
[ftp, f] = ft_window(track_name, duration, start_time, min_bpm, max_bpm);

% Find the FT for each window and sum up the magnitude responses
while(start_time + 2*duration < track_length(track_name))
    start_time = start_time + duration;
    
    [ftp_i, ~] = ft_window(track_name, duration, start_time, min_bpm, max_bpm);
    
    %temp fix
    ftp_i = ftp_i(length(ftp_i) - length(ftp)+1:length(ftp_i));
    
    ftp = abs(ftp) + abs(ftp_i);
    
end

figure();
plot(f,ftp)
xlim([0 10])
title("Frequency response of summed FTs")
xlabel("Frequency (Hz)")
ylabel("Magnitude")

%Find dominant frequency
maxPeak= max(ftp);
dominantFreq=f(ftp==maxPeak);
BPM = dominantFreq*60;

disp("BPM: " + BPM)

%Functions
function tk_len = track_length(track_name)
    
    [x, fs]=audioread(track_name);
    tk_len = length(x)/fs;

end

