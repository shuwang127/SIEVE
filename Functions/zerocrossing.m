function [ ZCR ] = zerocrossing( y, L )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Reading audio file
y0 = y(:,1);
clear y;

%% Setting parameters
L_all = size(y0, 1);
N_win = floor(L_all / L);
ZCR = zeros(N_win, 1);

%% Traverse the win(i)
for i = 1
    win = 1 : L;
    y_win = y0(win);
    for j = 1 : (L-1)
        if (y_win(j) * y_win(j+1) < 0)
            ZCR(i) = ZCR(i) + 1;
        end
    end
    ZCR(i) = ZCR(i) / (L-1);
end

for i = 2 : N_win
    win = (i*L-L) : (i*L);
    y_win = y0(win);
    for j = 1 : L
        if (y_win(j) * y_win(j+1) < 0)
            ZCR(i) = ZCR(i) + 1;
        end
    end
    ZCR(i) = ZCR(i) / L;
end

end

