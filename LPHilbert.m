clear all;
clc;

%% Read the recording
addpath('./Records/');
[y, fs] = audioread('test0_Multi.wav');
%[y, fs] = audioread('Records/test0_1.wav');
tic
y_L = y(:, 1);
y_R = y(:, 2);
clear y;
% y_L = y_L(500000:1000000);
% y_R = y_R(500000:1000000);
% plot(1:length(y_L), y_L);

%% Linear Predictation
[s_L, e_L] = LP(y_L, fs);
[s_R, e_R] = LP(y_R, fs);

% subplot(2,1,1)
% plot(1:length(e_L), e_L);
% subplot(2,1,2)
% plot(1:length(e_R), e_R);

%% Hilbert Transform
he_L = hilbert(e_L);
he_R = hilbert(e_R);
h_L = sqrt(e_L.^2 + imag(he_L).^2);
h_R = sqrt(e_R.^2 + imag(he_R).^2);
% subplot(2,1,1)
% plot(1:length(h_L), h_L);
% subplot(2,1,2)
% plot(1:length(h_R), h_R);

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
% subplot(2,1,1)
% plot(1:length(g_L), g_L);
% subplot(2,1,2)
% plot(1:length(g_R), g_R);

%% Cross Correlation
[WIN, MC] = crossCorr(g_L', g_R');

MC_total = zeros(1, size(MC,2));
%% Plot
for i = 1:size(MC,1)
%     subplot(2,1,1)
%     plot(1:length(g_L), g_L, 'b', WIN(i,:), g_L(WIN(i,:)), 'r');
%     subplot(2,1,2)
%     plot((1-size(MC,2))/2:(size(MC,2)-1)/2, MC(i,:));
    
    [~,ind] = max(MC(i,:));
    MC_total(ind) = MC_total(ind) + 1;
    %MC_total = MC_total + MC(i,:);
    %pause
end

MC_t = zeros(size(MC_total));
for i = 1:41
    MC_t(25*i-12) = sum(MC_total((25*i-24):(25*i)));
end
MC_t = MC_t / sum(MC_t) * 100;

%%
clear figure
% plot((1-size(MC,2))/2:(size(MC,2)-1)/2, MC_total);
plot((1-size(MC,2))/2:(size(MC,2)-1)/2, MC_t);
axis([-600,600,0,50])
xlabel('Offset');
ylabel('Percentage (%)');
sum(MC_total(462:562))/sum(MC_total)
toc

