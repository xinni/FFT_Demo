%% Clear all
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.

%% Define parameters
fontSize = 16;
columns = 1024;
rows = 1024;
width = 300; %% cosing function part width
outputImage = ones(rows,columns)*255;

maskWidth = 30;
% (413, 513)
% (614, 513)

%% Define the cosine function frequencies
abc = 200;
x = 1 : columns;
period = columns/abc;
y = 0.5 * cos(2*pi*x/period) + 0.5; % for horizontal

p = 1 : rows;
period2 = rows/200;
q = 0.5 * cos(2*pi*p/period2) + 0.5; % for vertical

s = 1 : columns;
period3 = columns/100;
t = 0.5 * cos(2*pi*s/period3) + 0.5; % for 45

%% Generate the image
tempImage = zeros(width,rows)*255;
for i = 1:width
    tempImage(i,:) = t * 255;
end

slop = 30;
tempImage = imrotate(tempImage, slop);
%[a, b, c] = size(tempImage);
% subplot(2, 2, 2);
% imshow(tempImage,[]);

for i = 1:width
    outputImage(i,:) = y * 255;
end

for i = 1:width
    outputImage(:,i) = q * 255;
end

for i = width+1:rows
    outputImage(i, width+1:columns) = tempImage(i - width, 1:columns - width);
end

%% Display the image
% subplot(2, 3, 1);
figure, imshow(outputImage,[]);

filename=['sImage' num2str(abc) '.jpg'];
saveas(gcf,filename);
close(gcf);
% title('Original Grayscale Image', 'FontSize', fontSize);
% 
% 
% % Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% % Give a name to the title bar.
% set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 

%% Image FFT
[r, c] = size(outputImage);
M = fft2(outputImage);
M = fftshift(M);

Ab = abs(M);
Abt = (Ab - min(min(Ab)))./(max(max(Ab))).*255;
% subplot(2, 3, 2);
figure, imshow(Abt),title('FFT Image', 'FontSize', fontSize) % Display the result

filename=['fImage' num2str(abc) '.jpg'];
saveas(gcf,filename);
close(gcf);

%%
for i = (columns-maskWidth)/2 : (columns-maskWidth)/2+maskWidth
    for j = (rows/2-100-maskWidth/2) : (rows/2-100-maskWidth/2)+maskWidth
        M(i,j) = 255;
    end
end

for i = (columns-maskWidth)/2 : (columns-maskWidth)/2+maskWidth
    for j = (rows/2+100-maskWidth/2) : (rows/2+100-maskWidth/2)+maskWidth
        M(i,j) = 255;
    end
end

sf = 200;
center1y = int32(rows/2 - cosd(slop)*sf);
center1x = int32(columns/2 + sind(slop)*sf);
for i = center1y - (maskWidth/2) : center1y + (maskWidth/2)
    for j = center1x - (maskWidth/2) : center1x + (maskWidth/2)
        M(j,i) = 255;
    end
end

center2y = int32(rows/2 + cosd(slop)*sf);
center2x = int32(columns/2 - sind(slop)*sf);
for i = center2y - (maskWidth/2) : center2y + (maskWidth/2)
    for j = center2x - (maskWidth/2) : center2x + (maskWidth/2)
        M(j,i) = 255;
    end
end
% subplot(2,3,4);
% imshow(M);

Ab = abs(M);
Abt = (Ab - min(min(Ab)))./(max(max(Ab))).*255;
% subplot(2, 3, 3);
% imshow(Abt),title('FFT Image Edit', 'FontSize', fontSize) % Display the result
% thresh = 0.90;
% mask = Abt > thresh;
% Abt(mask) = 0;
% M(mask) = 0;
% subplot(2, 3, 3);
% imshow(Abt),title('FFT Image Edit', 'FontSize', fontSize) % Display the result
%% Reconstructed Image
F = fftshift(M);
f = ifft2(F);
% subplot(2, 3, 6);
% imshow(f,[]),title('reconstructed Image', 'FontSize', fontSize)

%% Filter
% % Find pixels that are brighter than the threshold.
% mask = fabs > thresh; 
% % Erase those from the image
% fabs(mask) = 0;
% % Shift back and inverse fft
% filteredImage = ifft2(fftshift(fabs)) + mean2(I);
% imshow(filteredImage, []);

