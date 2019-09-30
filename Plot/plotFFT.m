function [ o1, o2, o3  ] = plotFFT(freq, amp, phase, freqStart, freqEnd )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if ( nargin == 3 )
	freqStart = freq(1);
    freqEnd = freq(end/2);
end

if ( freqStart <= 0 || freqStart > freq(end/2))
    freqStart = freq(1);
end

if ( freqEnd <= 0 || freqEnd > freq(end/2))
    freqEnd = freq(end/2);
end

freqindex = find( (freqStart <= freq) & (freq <= freqEnd) );

figure;
subplot(211);
plot(freq(freqindex), amp(freqindex));
title('Amplitude');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
% Plot the FFT phase image
subplot(212);
plot(freq(freqindex), phase(freqindex));
title('Phase');
xlabel('Frequency(Hz)');
ylabel('Phase');

o1 = freq(freqindex);
o2 = amp(freqindex);
o3 = phase(freqindex); 

end

