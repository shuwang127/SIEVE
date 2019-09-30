% Mutual Correlation Function with Different Speakers
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
data_test = [];     % testing data
label_test = [];    % testing label

%% Set parameters
L = 512;            % window length
d = 64;             % internal length
S0 = 64;            % Max Shift S0 <= d
P_th = 0.570;       % Power Threshold

%% read auto-correlation
[MC, MK] = mutualcorread( 'test0_1.wav', L, d, S0, P_th );
LB = (1/sqrt(2)) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(83, :)];
label_test = [label_test; label(83, :)];
% 225

[MC, MK] = mutualcorread( 'test0_2.wav', L, d, S0, P_th );
LB = (-1/sqrt(2)) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(225+73, :)];
label_test = [label_test; label(225+73, :)];
% 398

[MC, MK] = mutualcorread( 'test0_3.wav', L, d, S0, P_th );
LB = (0.25) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(398+79, :)];
label_test = [label_test; label(398+79, :)];
% 571

[MC, MK] = mutualcorread( 'test0_4.wav', L, d, S0, P_th );
LB = (0.93) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(571+71, :)];
label_test = [label_test; label(571+71, :)];
% 744

[MC, MK] = mutualcorread( 'test0_Driver.wav', L, d, S0, P_th );
LB = (0) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(744+69, :)];
label_test = [label_test; label(744+69, :)];
% 917

%%
mark0 = zeros(size(label));
dp = 15; dr = 5;
for i = 1:size(label,1)
    if (label(i) == -1/sqrt(2))                     % L1
        [m, r] = max( data(i,:) );
        p = 10; 
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == 0.25)                       % L2
        [m, r] = max( data(i,:) );
        p = -6;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == 0.93)                       % L3
        [m, r] = max( data(i,:) );
        p = -12;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == (1/sqrt(2)))                % L4
        [m, r] = max( data(i,:) );
        p = -10;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == 0)                          % Driver
        [m, r] = max( data(i,:) );
        p = 0;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    end
end

%% Plot the self-correlation curves for all the speakers.
% Normalize using the maximum value.
% x = 10 .^ x;
figure;
for i = [2,3,4,1,5]
    [m, ~] = max(data_test(i, :));
    data_test(i, :) = 10 .^ ( data_test(i,:) / m );
    x = -30 : 30;
    plot(x, data_test(i,x+65));
    hold on;
end
title('Cross Correlation Function of Different Speakers')
xlabel('Offset Value');
ylabel('Cross Correlation Value');
legend('L1', 'L2', 'L3', 'L4', 'Driver');

%% 'L1', 'L2', 'L3', 'L4', 'Driver'
% stat = [];
% for lb = [ -1/sqrt(2), 0.25, 0.93, 1/sqrt(2), 0 ]
%     mk = ( mark0 & (label == lb));
%     ind = find(mk == 1);
%     dat = data(ind, :);
%     mdat = [];
%     lb0 = 0;
%     for i = 1 : size(dat, 1)
%         [m, idx] = max(dat(i, :));
%         mdat = [mdat, idx-65];
%         if abs(idx-65) <= 2
%             lb0 = lb0 + 1;
%         end
%     end
%     %stat = [stat; lb, lb0, length(mdat), mean(mdat), mode(mdat), median(mdat), std(mdat)];
% end

%%