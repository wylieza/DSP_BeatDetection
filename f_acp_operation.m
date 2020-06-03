%AUTHOR - Justin
%Returns the first half of the ACF of the moving power for a window of
%samples. (Includes the highest point - ie. the anker). Designed to take in
%the out put from the f_mv_pwr function.
%Takes: [window of mvpwr values]
%returns: [mvpwr_acf_values]

function result_values = f_acp_operation(mvpwr_values)

%auto-correlation of the moving power
result_values = xcorr(mvpwr_values);

%remove the second half, but including the highest point (anchor)
[~, maxi] = max(result_values);
result_values = result_values(1:maxi);