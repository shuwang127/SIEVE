clear;
close all;

M = [66.0784, 67.2078, 65.9834, 64.7472, 64.8462;
     52.5832, 56.7796, 55.8656, 56.7798, 57.0040;
     59.1088, 57.3455, 55.7969, 55.0177, 53.7640;
     51.6012, 58.1030, 58.5000, 57.1012, 59.1000;
     59.1000, 58.1000, 54.4000, 55.0000, 54.3000];

expV = [65, 58, 55, 58, 55];

for i = [3, 2, 1, 4, 5]
    val = abs(M(i, :) - expV(i));
    plot(1:5, val);
    hold on;
end

%title('Relationship between distance and measuring error');
xlabel('Distance(ft)');
ylabel('Measuring Error (offset unit)');
legend( '0', '\pi/4', '\pi/2', '3\pi/4', '\pi');

% clear;
% close all;
% 
% M = [54.8308, 53.0147, 56.3371, 56.9032;
%      56.1263, 56.2312, 56.2331, 57.2723;
%      64.7472, 65.9834, 64.8462, 65.0784;
%      56.0120, 56.6499, 56.9180, 57.2131;
%      54.3123, 54.6724, 55.2385, 56.2307];
% 
% expV = [54, 55.5, 65, 55.5, 54];
% 
% for i = [1, 2, 3, 4, 5]
%     val = abs(M(i, :) - expV(i));
%     plot([0.5, 1, 1.5, 2], val);
%     hold on;
% end
% 
% xlabel('Height (ft)');
% ylabel('Measuring Error (offset unit)');
% legend( '0', '\pi/4', '\pi/2', '3\pi/4', '\pi');

clear;
close all;

M = [64, 65, 65, 65; % Center
    62, 63, 63, 65;  % Front
    67, 65, 65, 67;  % Back
    63, 64, 63, 63;  % Left
    67, 66, 68, 66]; % Right

expV = 65;

for i = [1, 2, 3, 4, 5]
    val = - (M(i, :) - expV);
    plot([1,2,3,4], val, 'o-');
    hold on;
end

axis([0.5 4.5 -4 4]);
xlabel('Instances');
ylabel('Offset Value (unit)');
legend( 'Normal', 'Front', 'Rear', 'Left', 'Right');