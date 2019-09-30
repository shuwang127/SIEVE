function [ss e] = LP(s, fs)
% Implementation of a basic short-time Linear Prediction (LP) Analysis and
% Synthesis Framwork using the Autocorrelation Method
% This MATLAB code implements an LP Analysis-Synthesis System based on the
% Autocorrelation Method. It calculates the LPC coefficients using the
% Levinson's Recursion. There is also a provision for bandwidth
% modification in order to circumvent the problem of a "nasal" sounding
% synthesis. In addition, denoising filters that raise the input formants
% above the noise floor and shape the noise are implemented.


%% Problem Setup
Ls = length(s);        % Number of samples
Lw = 0.01;             % Frame Length = Window Length (in s)
Lw = Lw * fs;          % Frame Length = Window Length (in samples)
Lt = 0.005;             % Frame Skip Amount = Window Shift (in s)
Lt = Lt * fs;          % Frame Skip Amount = Window Shift (in samples)                                  
p  = 12;               % Predictor Order
w  = hamming(Lw)';	   % Analysis Window

%% Short-time LP Analysis
x  = buffer(s, Lw, Lw/2, 'nodelay');	% Buffer the speech signal into short-time frames
rr = zeros(1, 2*Lw-1);
r  = zeros(size(x, 2), p+1);
a  = ones(size(x, 2), p+1);
k  = zeros(size(x,2), p);
er = zeros(1, size(x, 2));

%%
for i = 1 : size(x, 2)
    sw = x(:, i)';                                  % Short-time frame of input
    sw = sw .* w;                                   % Windowed short-time frame
    rr = xcorr(sw, sw);                             % Short-time autocorrelation vector (entire frame)
    r(i, :) = rr(Lw : Lw+p);                        % Short-time autocorrelation vector relevant to the Levinson Recursion
    R = toeplitz(r(i, 1:p));                        % Autocorrelation Matrix (not used in the implementation)
    if nnz(sw) == 0
        a(i, 2:p+1) = 0;                            % If autocorrelation values are 0, the autocorrelation matrix will become singular
    else
        [a(i,:) er(i) k(i,:)] = levinson(r(i,:),p);	% Use of Levinson's Recursion to calculate prediction and reflection coefficients
    end
end

%% Generation of Error Signal
[e(1:Lt) zf] = filter(a(1,:), 1, s(1:Lt));
for l = 1 : floor(length(s)/Lt)-1
    zi = zf;
    [e(l*Lt+1:l*Lt+Lt) zf] = filter(a(l+1,:), 1, s(l*Lt+1:l*Lt+Lt), zi);
end

%% Synthesis
[ss(1:Lt) zf] = filter(1, a(1,:), e(1:Lt));
for l=1 : floor(length(e)/Lt)-1
    zi = zf;
    [ss(l*Lt+1:l*Lt+Lt) zf] = filter(1, a(l+1,:), e(l*Lt+1:l*Lt+Lt), zi);
end
%% Bandwidth Modification

% a_bm = ones(length(x),p+1);
% alpha = 1.05;                                % Bandwidth Modification Factor
% for i = 1:length(x)
%     for l=1:p+1
%         a_bm(i,l) = alpha^(l-1) * a(i,l);                   % Prediction coefficents after bandwidth modification by alpha
%     end
% end
% 
% a_bmi = ones(length(x),p+1);
% for i = 1:length(x)
%     for l=1:p+1
%         a_bmi(i,l) = alpha^(1-l) * a(i,l);                   % Prediction coefficents after bandwidth modification by alpha^-1
%     end
% end

%% Synthesis with Bandwidth Modification

% [ssb(1:Nt) zf] = filter(1,a_bmi(1,:),e(1:Nt));
% for l=1:floor(length(e)/Nt)-1
%     zi = zf;
%     [ssb(l*Nt+1:l*Nt+Nt) zf] = filter(1,a_bmi(l+1,:),e(l*Nt+1:l*Nt+Nt),zi);
% end

%% Processing of Speech corrupted by AWGN

% y = wavread('noisy3sentences.wav');                         % Replace 'noisy3sentences.wav' with input file name
% 
% % Filter A(alpha*z) applied
% [y1(1:Nt) zf] = filter(a_bm(1,:),1,y(1:Nt));
% for l=1:floor(length(y)/Nt)-1
%     zi = zf;
%     [y1(l*Nt+1:l*Nt+Nt) zf] = filter(a_bm(l+1,:),1,y(l*Nt+1:l*Nt+Nt),zi);
% end
% 
% % Filter A(alpha^-1*z) applied
% [y2(1:Nt) zf] = filter(a_bmi(1,:),1,y(1:Nt));
% for l=1:floor(length(y)/Nt)-1
%     zi = zf;
%     [y2(l*Nt+1:l*Nt+Nt) zf] = filter(a_bmi(l+1,:),1,y(l*Nt+1:l*Nt+Nt),zi);
% end
% 
% % Filter 1/A(alpha*z)
% [y3(1:Nt) zf] = filter(sqrt(er(1)),a_bm(1,:),y(1:Nt));
% for l=1:floor(length(y)/Nt)-1
%     zi = zf;
%     [y3(l*Nt+1:l*Nt+Nt) zf] = filter(sqrt(er(l+1)),a_bm(l+1,:),y(l*Nt+1:l*Nt+Nt),zi);
% end
% 
% % Filter 1/A(alpha^-1*z) applied
% [y4(1:Nt) zf] = filter(er(1),a_bmi(1,:),y(1:Nt));
% for l=1:floor(length(y)/Nt)-1
%     zi = zf;
%     [y4(l*Nt+1:l*Nt+Nt) zf] = filter(er(l+1),a_bmi(l+1,:),y(l*Nt+1:l*Nt+Nt),zi);
% end
% 
% % Filter 1/A(z) applied
% [y5(1:Nt) zf] = filter(er(1),a(1,:),y(1:Nt));
% for l=1:floor(length(y)/Nt)-1
%     zi = zf;
%     [y5(l*Nt+1:l*Nt+Nt) zf] = filter(er(l+1),a(l+1,:),y(l*Nt+1:l*Nt+Nt),zi);
% end
