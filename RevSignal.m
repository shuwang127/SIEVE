% Received signals

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

[MC, MK] = mutualcorread( 'test_LR0.wav', L, d, S0, P_th );