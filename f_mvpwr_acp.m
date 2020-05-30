%AUTHOR - Justin
%Returns the first half of the ACF of the moving power for a window of
%samples. (Includes the highest point - ie. the anker)
%Takes: [window values]
%returns: [mvpwr_acf_values]

function result_values = f_mvpwr_acp(window_values)

%META PARAMETERS
mving_ave_samples = 15;

%calculate the moving power
moving_pwr = movmean(window_values.^2, mving_ave_samples);

%auto-correlation of the moving power
result_values = xcorr(moving_pwr);

%remove the second half, but including the highest point (anchor)
[~, maxi] = max(result_values);
result_values = result_values(1:maxi);

end