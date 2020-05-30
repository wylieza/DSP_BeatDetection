function pfit_line = acp_bestfitline(acpshort, line_width) %Linewidth is in seconds

index = 1;
width = line_width*44100; %in samples
offset = 0; %offset from the current curve

while((index + width) < length(acpshort))
    pfit_coeff = polyfit(1:width, acpshort(index:(index+width-1)), 1);
    pfit_line(index:(index+width-1)) = arrayfun(@(x) x + offset, linspace(0, width - 1, width).*pfit_coeff(1));
    offset = pfit_line(index+width-1);
    index = index + width;
end
%Deal with the last 'left over' bit of samples
width = mod(length(acpshort),width);
pfit_coeff = polyfit(1:width, acpshort(index:(index+width-1)), 1);
pfit_line(index:(index+width-1)) = arrayfun(@(x) x + offset, linspace(0, width - 1, width).*pfit_coeff(1));

%Plot the autocorrelation of the moving ave pwr with the best fit
%figure
%plot(tacpshort, acpshort);
%hold on;
%plot(tacpshort, pfit_line);
%hold off;
%title("Plot of autocorrelated moving average power")
%xlabel('Time (s)')

end