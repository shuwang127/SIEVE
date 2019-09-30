% Multi-Path Analysis
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
SA = 512;           % Max Shift SA
P_th = 0.570;       % Power Threshold

%% Auto-Correlation Value Calculation
% [AC, MK] = autocorread( 'MultiSpeakers.wav', L, SA, P_th );
% LB = ones( size(AC,1), 1 );
% data = [data; AC];
% mark = [mark; MK];
% label = [label; LB];
% 
% [AC, MK] = autocorread( 'test0_2.wav', L, SA, P_th );
% LB = zeros( size(AC,1), 1 );
% data = [data; AC];
% mark = [mark; MK];
% label = [label; LB];
% 
%% Testing Mutual Correlation for Mutual Speakers
% [MC, MK] = mutualcorread( 'test0_Multi.wav', L, 64, 64, P_th );
% for i = 1 : size(MC,1)
%     plot(-64:64, MC(i,:));
%     pause
% end

%% Zero crossing rate
L = 2000;
y1 = audioread('test0_Multi.wav');
y2 = audioread('test0_3.wav');
[ZCR1] = zerocrossing( y1, L );
[ZCR2] = zerocrossing( y2, L );
subplot(2,1,1);
plot(1:size(y1,1), y1(:,1), 'r', 1:size(y2,1), y2(:,1), 'b');
legend('Multi Speakers','Single Speaker');
subplot(2,1,2);
plot(1:length(ZCR1), ZCR1, 'r', 1:length(ZCR2), ZCR2, 'b')
legend('Multi Speakers','Single Speaker');