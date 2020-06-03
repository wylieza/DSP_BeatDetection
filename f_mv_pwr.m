%AUTHOR - Justin
%Returns the first half of the ACF of the moving power for a window of
%samples. (Includes the highest point - ie. the anker)
%Takes: [window values]
%returns: [mvpwr_acf_values]

function result_values = f_mv_pwr(window_values)

%META PARAMETERS
mving_ave_samples = 15;

%calculate the moving power
result_values = movmean(window_values.^2, mving_ave_samples);

end