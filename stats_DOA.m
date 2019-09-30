% Confirmation of DOA
% Author: Shu Wang
%         Center for Secure Information System
%         George Mason University

%% clear all
clear;
clc;
close all;
addpath( './Functions' );
addpath( './Plot' );
addpath( './Records' );

%% Set Buffer
data = [];          % training data
mark = [];          % marking signal or noise
label = [];         % labeling the direction

%% Set parameters
L = 512;            % window length
d = 64;             % internal length
S0 = 64;            % Max Shift S0 <= d
P_th = 0.570;       % Power Threshold

%% read self-correlation
[MC, MK] = mutualcorread( 'TASCAM_0094.wav', L, d, S0, P_th );

%% calculate baseline mark
mark0 = zeros(1, size(MC, 1));
dp = 15; dr = 15;
for i = 1:size(MC, 1)
    [m, r] = max( MC(i,:) );
    p = -10;
    if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
        mark0(i) = judgeconvex( MC(i,:), r, dr );
    end
end
fprintf( 'Totally %d samples...\n', sum(mark0) );

%% calculate mark
Result = [];
for i = 1:size(MC, 1)
    if MK(i) == 1 && mark0(i) == 1
        [m, r] = max( MC(i,:) );
        Result = [Result, r];
    end
end
size(Result,2)
65-mean(Result)
std(Result)