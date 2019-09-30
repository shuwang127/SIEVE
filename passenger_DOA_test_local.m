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
[MC, MK] = mutualcorread( 'TASCAM_0077.wav', L, d, S0, P_th );
LB = (1/sqrt(2)) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(1000, :)];
label_test = [label_test; label(1000, :)];
% 6067
count1 = zeros(1, 2*S0+1);
index1 = [];
for i = 1 : length(data)
    if mark(i) == 1
        %plot(-S0:S0, data(i,:));
        [~, ind] = max(data(i,:));
        count1(ind) = count1(ind) + 1;
        index1 = [index1, ind];
        %fprintf('%d, %d\n', i, ind-S0-1);
        %pause
    end
end
%plot(-S0:S0, count1);

[MC, MK] = mutualcorread( 'TASCAM_0079.wav', L, d, S0, P_th );
LB = (-1/sqrt(2)) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(6067+571, :)];
label_test = [label_test; label(6067+571, :)];
% 6015
count2 = zeros(1, 2*S0+1);
index2 = [];
for i = 6068 : length(data)
    if mark(i) == 1
        %plot(-S0:S0, data(i,:));
        [~, ind] = max(data(i,:));
        count2(ind) = count2(ind) + 1;
        index2 = [index2, ind];
        %fprintf('%d, %d\n', i, ind-S0-1);
        %pause
    end
end
%plot(-S0:S0, count2);

[MC, MK] = mutualcorread( 'TASCAM_0080.wav', L, d, S0, P_th );
LB = (0.25) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(6067+6015+366, :)];
label_test = [label_test; label(6067+6015+366, :)];
% 5751
count3 = zeros(1, 2*S0+1);
index3 = [];
for i = (6068+6015) : length(data)
    if mark(i) == 1
        %plot(-S0:S0, data(i,:));
        [~, ind] = max(data(i,:));
        count3(ind) = count3(ind) + 1;
        index3 = [index3, ind];
        %fprintf('%d, %d\n', i, ind-S0-1);
        %pause
    end
end
%plot(-S0:S0, count3);

[MC, MK] = mutualcorread( 'passenger4.wav', L, d, S0, P_th );
LB = (0.93) * ones( size(MC,1), 1 );
data = [data; MC];
mark = [mark; MK];
label = [label; LB];
data_test = [data_test; data(6067+6015+5751+1161, :)];
label_test = [label_test; label(6067+6015+5751+1161, :)];
% 6547
count4 = zeros(1, 2*S0+1);
index4 = [];
for i = (6068+6015+5751) : length(data)
    if mark(i) == 1
        %plot(-S0:S0, data(i,:));
        [~, ind] = max(data(i,:));
        count4(ind) = count4(ind) + 1;
        index4 = [index4, ind];
        %fprintf('%d, %d\n', i, ind-S0-1);
        %pause
    end
end
%plot(-S0:S0, count4);

%% Plot the self-correlation curves for all the speakers.
% Normalize using the maximum value.
% x = 10 .^ x;
figure;
for i = [1,2,4,3]
    [m, ~] = max(data_test(i, :));
    rdata(i, :) = 10 .^ ( data_test(i,:) / m );
    x = -30:30;
    plot(-x, rdata(i,x+65));
    hold on;
end
title('Cross Correlation Function of Different Seats')
xlabel('Offset Value s');
ylabel('Cross Correlation Value');
legend('Driver', 'Passenger1', 'Passenger2', 'Passenger3');

%%
figure;
x = -30:30;
plot(-x, count1(35:95)); hold on;
plot(-x, count2(35:95)); hold on;
plot(-x, count4(35:95)*0.8); hold on;
plot(-x, count3(35:95)/2); hold on;
title('Cross Correlation Statistics of Different Seats')
xlabel('Offset Value s');
ylabel('# Signal Segments');
legend('Driver', 'Passenger1', 'Passenger2', 'Passenger3');
