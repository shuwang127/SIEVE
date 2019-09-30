function [ MK ] = calmark( file_name, L, d, S0, P_th )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Read the audio file
[y, fs] = audioread( file_name );
y_L = y( :, 1 );
y_R = y( :, 2 );
clear y;

%% Set arguments
if nargin < 2
    L = 512;                % window length
end
if nargin < 3
    d = 64;                 % internal length
end
if nargin < 4
    S0 = 64;                % Max Shift S0 <= d
end
if nargin < 5
    P_th = 0.000;           % Power Threshold
end

%% Set parameters
L_all = size( y_R, 1 );                     % signal length
N_win = floor( ( L_all - d ) / ( L + d ) ); % windows number
MC = zeros( N_win, 2*S0+1 );                % Mutual-Correlation
MK = zeros( N_win, 1 );

%% Traverse each window (i)
for i = 1 : N_win
    win = (i*d+i*L-L+1) : (i*d+i*L);        % index the window
    y_Rwin = y_R( win );                    % get the R signal
    % y_Lwin = y_L( win );                  % get the L signal
    % plot(1:L, y_Lwin, 1:L, y_Rwin);       % plot R/L in window
    % pause
    
    [ freq, amp, ~ ] = fastFT( y_Rwin, fs );% FFT
    % plot(freq(1:256), amp(1:256));        % plot FFT
    % title('Amplitude');
    % xlabel('Frequency(Hz)');
    % ylabel('Amplitude');
    amp = amp(1:end/2);                     % shorten FFT map
    P = sum( amp(3:17).^2 ) / sum( amp.^2 );% cal bandpass power

    if ( P >= P_th )
        MK(i) = 1;
    end
end

end

