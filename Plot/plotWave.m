function [ ] = plotWave( y, fs, timeStart, timeEnd )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

t = (1 : length(y)) / fs;

if ( nargin == 2 )
	timeStart = t(1);
    timeEnd = t(end);
end

if ( timeStart <= 0 || timeStart > t(end))
    timeStart = t(1);
end

if ( timeEnd <= 0 || timeEnd > t(end))
    timeEnd = t(end);
end

timeindex = find( (timeStart <= t) & (t <= timeEnd) );

figure;
plot(t(timeindex), y(timeindex));
title('Time Domain Wave');
xlabel('time(sec)');
ylabel('relative signal strength');

end

