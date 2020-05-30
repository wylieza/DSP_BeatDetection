function bpm = get_bpm(indexi, indexf)
    bpm = 60/((indexf - indexi)/44100);
end
