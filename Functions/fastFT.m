function [ frequency, amplitude, phase ] = fastFT( signal, fs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Discrete Fourier Transforms
N = 2^nextpow2(length(signal));
Y = fft(signal, N) / N * 2;

% Analyse the Y
frequency = fs / N * (0:1:N-1);     % Frequency
amplitude = abs(Y);                 % Amplitude
phase = angle(Y);                   % Phase


end

