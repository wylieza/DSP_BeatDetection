%Returns the number of windows for a given set of samples and window length
%Takes: [[sample values], [window length]]
%returns: [number of windows]

function num_windows = f_num_windows(sample_values, window_len)

num_windows = length(sample_values)/window_len;

if (mod(num_windows, 1) > 0)
    num_windows = num_windows + 1;
end

num_windows = floor(num_windows);

end
