%Returns a window of samples for a window number (1 -> max)
%Takes: [[sample values], [window number], [window length]]
%returns: [[window of sample values], [sample indicies]]

function [window_values, window_indicies] = f_get_window(sample_values, window_num, window_len)

%load 'nothing' into return values
window_values = [];
window_indicies = [];


%calculate indicies
start_ind = ((window_num-1)*window_len)+1;
if start_ind > length(sample_values); end_ind = length(sample_values); else; end_ind = (start_ind + window_len); end;

%check window number does not exceed beyond those available
if start_ind < length(sample_values)
    window_values = sample_values(start_ind:end_ind);
    window_indicies = (start_ind:end_ind);
end

end