% Confirmation of DOA
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
d = 64;             % internal length
S0 = 64;            % Max Shift S0 <= d
P_th = 0.570;       % Power Threshold

%% read self-correlation
[MC, MK] = mutualcorread( 'test_LR0.wav', L, d, S0, P_th );
LB = ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];

[MC, MK] = mutualcorread( 'test_LR45.wav', L, d, S0, P_th );
LB = (1/sqrt(2)) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];

[MC, MK] = mutualcorread( 'test_M90.wav', L, d, S0, P_th );
LB = (0) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];

[MC, MK] = mutualcorread( 'test_RL135.wav', L, d, S0, P_th );
LB = (-1/sqrt(2)) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];

[MC, MK] = mutualcorread( 'test_RL180.wav', L, d, S0, P_th );
LB = (-1) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
fprintf( 'Totally %d extracted samples...\n', sum(mark) );

%% save the data
save Data/data.mat data mark label
clear MC LB;

%% load the data
load Data/data.mat

%% calculate baseline mark
mark0 = zeros(size(label));
dp = 7; dr = 15;
for i = 1:size(label,1)
    if (label(i) == 1)                      % LR0
        [m, r] = max( data(i,:) );
        p = -14; 
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == (1/sqrt(2)))        % LR45
        [m, r] = max( data(i,:) );
        p = -7;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == 0)                  % 90
        [m, r] = max( data(i,:) );
        p = 0;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == (-1/sqrt(2)))       % RL135
        [m, r] = max( data(i,:) );
        p = 7;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    elseif (label(i) == -1)                 % RL180
        [m, r] = max( data(i,:) );
        p = 14;
        if ( ( r>=(65+p-dp) ) && ( r<=(65+p+dp) ) )
            mark0(i) = judgeconvex( data(i,:), r, dr );
        end
        
    end
end
fprintf( 'Totally %d samples...\n', sum(mark0) );

%% calculate mark
% Result = zeros(101,1);
% i = 1;
% for P_th = 0.0:0.01:1.0
%     mark = [];
%     MK = calmark( 'test_LR0.wav', L, d, S0, P_th );
%     mark = [mark; MK];
%     MK = calmark( 'test_LR45.wav', L, d, S0, P_th );
%     mark = [mark; MK];
%     MK = calmark( 'test_M90.wav', L, d, S0, P_th );
%     mark = [mark; MK];
%     MK = calmark( 'test_RL135.wav', L, d, S0, P_th );
%     mark = [mark; MK];
%     MK = calmark( 'test_RL180.wav', L, d, S0, P_th );
%     mark = [mark; MK];
%     Result(i) = sum(abs(mark-mark0));
%     fprintf('%.2f-%d\n', P_th, Result(i));
%     i = i + 1;
% end

% R = [0,0;0,0];
% for i = 1:size(mark,1)
%     if ( mark(i) == 0 && mark0(i) == 0 )
%         R(1,1) = R(1,1) + 1;
%     elseif ( mark(i) == 0 && mark0(i) == 1 )
%         R(1,2) = R(1,2) + 1;
%     elseif ( mark(i) == 1 && mark0(i) == 0 )
%         R(2,1) = R(2,1) + 1;
%     elseif ( mark(i) == 1 && mark0(i) == 1 )
%         R(2,2) = R(2,2) + 1;
%     end
% end

figure;
for i = [848, 25084, 47288, 72869, 96651]
    if mark0(i) == 1 && mark(i) == 1 %&& label(i) == -1/sqrt(2)
        [m, ind] = max(data(i, :));
        rdata(i, :) =  10 .^ ( data(i,:) / m );
        x = -30 : 30;
        plot(-x, rdata(i, x+65));
        %fprintf('%d-%d-%.3f\n', i, ind-65, label(i))
        hold on
    end
end
%848-25084-47288-72724/72869-96651
title('Cross Correlation Function of Different Speakers')
xlabel('Offset Value');
ylabel('Cross Correlation Value');
legend('0', '\pi/4', '\pi/2', '3\pi/4', '\pi');
%% Regression
