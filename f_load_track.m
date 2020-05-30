%AUTHOR - Justin
%Loads in a track
%Takes: [track name]
%returns: [[track sample values], [sampling frequency], [sample times]]

function [track_sv, track_sf, track_st] = f_load_track(track_name)

%read track
[track_sv, track_sf]=audioread(track_name);

%generate time indicies
track_st = 0:1/fs:(length(x)-1)/fs;

end