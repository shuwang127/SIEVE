function [  ] = plotMC( mc, i )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


S0 = ( size( mc, 2 ) - 1 ) / 2;
plot( -S0:S0, mc(i,:) )
title('Mutual Correlation');
xlabel('Shift');
ylabel('Mutual Correlation');

end

