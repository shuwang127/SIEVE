clear;
clc;

%% generate the roots of besselj(0, x) = 0
% lambdaTemp = [];
% for count = 1 :0.01: 1000
%     root = fzero(@(x) besselj(0,x), count);
%     lambdaTemp = [lambdaTemp; root];
%     if mod(count,100) == 0
%         fprintf('%6d Finished!\n', count);
%     end
% end
% lambdaTemp = sort(lambdaTemp);
% 
% %
% lambdaM = lambdaTemp(1);
% for count = 2 : length(lambdaTemp)
%     if (lambdaTemp(count) - lambdaM(end)) > 1e-3
%         lambdaM = [lambdaM; lambdaTemp(count)];
%     end
% end
% fprintf('Finished!\n');

load lambdaM.mat
M = 500;

%% Read the recording
addpath('./Records/');
[y, fs] = audioread('test0_1.wav');
y_L = y(:, 1);
y_R = y(:, 2);
clear y;
% y_L = y_L(32000:48000);
% y_R = y_R(32000:48000);
% plot(1:length(y_L), y_L);

%% Calculate Fourier-Bessel coefficients
N = size(y_L, 1) - 1;
x = 0 : N;
CM_L = zeros(M, 1);
CM_R = zeros(M, 1);
for mInd = 1 : M
    temp = x .* y_L(x+1)' .* besselj(0, lambdaM(mInd) * x / N);
    CM_L(mInd) = 2 * sum(temp) / (N * N * besselj(1, lambdaM(mInd))^2);
    temp = x .* y_R(x+1)' .* besselj(0, lambdaM(mInd) * x / N);
    CM_R(mInd) = 2 * sum(temp) / (N * N * besselj(1, lambdaM(mInd))^2);
end
% plot(1:length(CM_L), CM_L, 1:length(CM_R), CM_R);

%% Reconstruction
% mark = [zeros(300, 1); ones(200, 1)];
lambdaMM = lambdaM(1:M);
Bessel0 = besselj(0, lambdaMM * (0:N) / N);
yr_L = ((CM_L)' * Bessel0)';
yr_R = ((CM_R)' * Bessel0)';
subplot(2,1,1)
plot(1:length(y_L), y_L, 1:length(y_R), y_R);
subplot(2,1,2)
plot(1:length(yr_L), yr_L, 1:length(yr_R), yr_R);

%% Find the residual
r_L = y_L - yr_L;
r_R = y_R - yr_R;

%% Hilbert Transform
hr_L = hilbert(r_L);
hr_R = hilbert(r_R);
h_L = sqrt(r_L.^2 + imag(hr_L).^2);
h_R = sqrt(r_R.^2 + imag(hr_R).^2);

%% preprocessed HE
M = 1000;
g_L = zeros(1, length(h_L)-2*M);
g_R = zeros(1, length(h_R)-2*M);
for mInd = 1:length(g_L)
    g_L(mInd) = h_L(mInd+M)^2;
    g_L(mInd) = g_L(mInd) * (2*M+1) / sum(h_L(mInd:(2*M+mInd)));
    g_R(mInd) = h_R(mInd+M)^2;
    g_R(mInd) = g_R(mInd) * (2*M+1) / sum(h_R(mInd:(2*M+mInd)));
end

%%
[WIN, MC] = crossCorr(g_L', g_L');

%% End of the program
for i = 1:size(MC,1)
    subplot(2,1,1)
    plot(1:length(g_L), g_L, 'b', WIN(i,:), g_L(WIN(i,:)), 'r');
    subplot(2,1,2)
    plot((1-size(MC,2))/2:(size(MC,2)-1)/2, MC(i,:));
    pause
end
fprintf('Finished!\n');