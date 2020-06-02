% AUTHOR - Kate
% Calculate a score for the computed beat locations

% Scoring system
% Every beat location within (tolerance) % of the beat interval of the 
% standard's locations = 1 point
% Score (%) = ((total points) / (number of beats in standard)) * 100

% Note the tolerance is w.r.t the time interval not the beat location
% (otherwise the tolerance range is larger for locations later in the song)

tolerance = 0.1; % 10% tolerance

disp("Beat Locations Score Generator")
% Get the standard and computed beat locations
disp("Song choices:" +newline+ "1 - Timelapse"+ newline + ...
    "2 - Lost" +newline+ "3 - Golddust" +newline+ "4 - Nostalgia" ...
    +newline+ "5 - Hey Brother" +newline+ "6 - 180 BPM Metronome with noise")
song_choice = input('Enter a song choice numer: '); % USER-ENTERED
beat_locations = input('Enter the computed beat locations array: '); % USER-ENTERED

% Get the info about the testing standard
[num_beats, time_interval, standard_locations] = f_get_song_info(song_choice);

% Find the number of times the beat locations computed lie within the 
% specified tolerance of the standard's locations

% Count number of matches within the specified tolerance
matches = 0;
for i=1:num_beats
    %if ~(isempty(find(abs(a(i)-b)<tolerance*time_interval,1)))
    if ~(isempty(find(abs(standard_locations(i)-beat_locations)<tolerance*time_interval,1)))
        matches=matches+1;
    end
    
end

score = (matches/num_beats)*100; % Score as a percentage
disp("Score for the computed beat locations: "+score+"%")

