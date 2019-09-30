function [ AC, MK ] = autocorread( file_name, L, SA, P_th )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% read the audio file.
[y, fs] = audioread( file_name );
y0 = y(:,1);
clear y;

%% Set arguments
if nargin < 2
    L = 512;                % window length
end
if nargin < 3
    SA = 512;               % Max Shift SA
end
if nargin < 4
    P_th = 0.570;           % Power Threshold
end

%% Set parameters
L_all = size( y0, 1 );                      % signal length
N_win = floor( ( L_all - 2 * SA ) / L );    % windows number
AC = zeros( N_win, 2 * SA + 1 );            % Mutual-Correlation
MK = zeros( N_win, 1 );

%% Traverse each window (i)
for i = 1 : N_win
    win = (SA+i*L-L+1) : (SA+i*L);
    y_win = y0(win);
    
%     subplot(2,1,1);
%     plot((i*L-L+1):(2*SA+i*L) , y0((i*L-L+1):(2*SA+i*L)), 'b', win, y_win, 'r');
    
    [ ~, amp, ~ ] = fastFT( y_win, fs );% FFT
    amp = amp(1:end/2);                     % shorten FFT map
    P = sum( amp(3:17).^2 ) / sum( amp.^2 );% cal bandpass power
    if ( P >= P_th )
        MK(i) = 1;
    end
    
    for j = 1 : (2 * SA + 1)
        s = j - SA - 1;
        yS_win = y0(win + s);
        AC( i, j ) = sum( y_win .* yS_win );
%         plot(1:L, y_win, 1:L, yS_win);
%         pause
    end
    AC( i, : ) = AC(i,:) / max(AC(i,:));
    
%     subplot(2,1,2);
%     plot( -SA:SA, AC(i,:) );
%     pause
end

end