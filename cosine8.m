%% Clear all
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.

%% Define parameters
fontSize = 16;
columns = 1024;
rows = 1024;
width = rows / 8; %% cosing function part width
outputImage = ones(rows,columns)*255;

%% Define the cosine function frequencies
p = 4;
x = 1 : columns;
period = columns/p;
y = 0.5 * cos(2*pi*x/period) + 0.5;

%% Generate
for j = 0 : 7
    for i = 1 + width*j : 1 + width*(j+1)
        outputImage(i,:) = y * 255;
    end
    p = p * 2;
    period = columns/p;
    y = 0.5 * cos(2*pi*x/period) + 0.5;
end

figure, imshow(outputImage,[]);
% print(gcf,'-dpng','abc.png') 