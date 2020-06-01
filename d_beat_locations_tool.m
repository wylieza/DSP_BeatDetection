% AUTHOR - Kate
% Find the beat locations

% USER ENTERED INFO
% select song choice
% 1 - Timelapse
% 2 - Lost
% 3 - Golddust
% 4 - Nostalgia
% 5 - Hey Brother
% 6 - 180 BPM Metronome with noise
disp("Song choices:" +newline+ "1 - Timelapse"+ newline + ...
    "2 - Lost" +newline+ "3 - Golddust" +newline+ "4 - Nostalgia" ...
    +newline+ "5 - Hey Brother" +newline+ "6 - 180 BPM Metronome with noise")
song_choice = input('Enter a song choice numer: '); % USER-ENTERED

% Using Audacity, identify the position (time in seconds) of a clear beat
beat_time = input('Enter position (time in seconds) of a beat: '); % USER-ENTERED

% Song info (from track_stats.txt)
switch song_choice
    case 1 % Timelapse
        length= 185; % Song duration in seconds
        num_beats= 392; % Total number of beats in the song
    case 2 % Lost
        length= 78; % Song duration in seconds
        num_beats= 110; % Total number of beats in the song
    case 3 % Golddust
        length= 183; % Song duration in seconds
        num_beats= 443; % Total number of beats in the song
    case 4 % Nostalgia
        length= 240; % Song duration in seconds
        num_beats= 336; % Total number of beats in the song
    case 5 % Hey Brother
        length= 263; % Song duration in seconds
        num_beats= 548; % Total number of beats in the song
    case 6 % 180 BPM Metronome with noise
        length= 150; % Song duration in seconds
        num_beats= 450; % Total number of beats in the song
    otherwise
        disp("Invalid song choice")
                
end




% CALCULATIONS
beat_locations = zeros(length,1); % No. beat locations = No. beats
time_interval=length/num_beats; % interval between beats

% Find the index number of the beat identified
beat_index=ceil(beat_time/time_interval); % round up - indexing starts at 0
beat_locations(beat_index) = beat_time; % Set the identified time at that index

% If the identified beat index is greater than 1, work out previous beat
% locations
if beat_index>1
    time = beat_time;
    for previous_index=[(beat_index-1):-1:1]
        time = time - time_interval;
        beat_locations(previous_index) = time;
    end
end

% Work out the beat locations following the identified beat
% If the identified beat was not the last one
if beat_index~=num_beats
        time = beat_time
        for index=[(beat_index+1):1:num_beats]
            time = time + time_interval;
            beat_locations(index) = time;   
        end   
end

% Round off time locations to 3 decimal places
beat_locations = round(beat_locations,3);

disp("The beat locations are stored in the array 'beat_locations'")