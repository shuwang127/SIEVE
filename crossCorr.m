function [ WIN, MC ] = crossCorr( y_L, y_R, L, d, S0, P_th )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Read the audio file

%% Set arguments
if nargin < 3
    L = 512;                % window length
end
if nargin < 4
    d = 512;                 % internal length
end
if nargin < 5
    S0 = 512;                % Max Shift S0 <= d
end
if nargin < 6
    P_th = 0.000;           % Power Threshold
end

%% Set parameters
L_all = size( y_R, 1 );                     % signal length
N_win = floor( ( L_all - d ) / ( L + d ) ); % windows number
MC = zeros( N_win, 2*S0+1 );                % Mutual-Correlation
WIN = zeros( N_win, L );

%% Traverse each window (i)
for i = 1 : N_win
    win = (i*d+i*L-L+1) : (i*d+i*L);        % index the window
    WIN(i, :) = win;
    y_Rwin = y_R( win );                    % get the R signal
    % y_Lwin = y_L( win );                  % get the L signal
    % plot(1:L, y_Lwin, 1:L, y_Rwin);       % plot R/L in window
    % pause
    
    P = sqrt( sum( y_Rwin.^2 ) / L );       % detect power
    if ( P >= P_th )
        for j = 1 : (2*S0+1)                        % traverse shifts
            s = j - S0 - 1;                         % in [-S0,S0]
            y_Lwin = y_L( win + s );                % shift the L signal
            MC( i, j ) = sum( y_Rwin .* y_Lwin );   % cal mutual-correlation
            MC( i, j ) = MC( i, j ) / sqrt(sum(y_Rwin.^2)*sum(y_L(win).^2));
            % plot(win, y_Lwin, win, y_Rwin);       % plot R/shift-L
            % pause
        end
        % plot(-S0:S0, MC(i,:));                    % plot mc(i) map
    end
end

end

