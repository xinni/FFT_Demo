%% Clear all
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.

%%
fingerPrint=imread('cosine8.png');
%Convert to grayscale
fingerPrint=rgb2gray(fingerPrint);
% imshow(fingerPrint);

PQ = paddedsize(size(fingerPrint));
width = 40;

for i = 20 : 100
    D0 = i * 2;
    H = lpfilter('ideal', PQ(1), PQ(2), D0);
    F=fft2(double(fingerPrint),size(H,1),size(H,2));
    LPFS_fingerPrint = H.*F;
    
    D0 = D0 - width;
    H = hpfilter('ideal', PQ(1), PQ(2), D0);
    LPFS_fingerPrint = H.*LPFS_fingerPrint;
    
    LPF_fingerPrint=real(ifft2(LPFS_fingerPrint));
    LPF_fingerPrint=LPF_fingerPrint(1:size(fingerPrint,1), 1:size(fingerPrint,2));


    %Display the blurred image
    figure, imshow(LPF_fingerPrint, []);
%     imwrite(LPF_fingerPrint,[],'myGray.png');
    filename=['sImage' num2str(i) '.jpg'];
    saveas(gcf,filename);
    close(gcf);
    
%     Fc=fftshift(F);
    Fcf=fftshift(LPFS_fingerPrint);

%     S1=log(1+abs(Fc));
    S2=log(1+abs(Fcf));
    % figure, imshow(S1,[])
    figure, imshow(S2,[]);
    filename=['fImage' num2str(i) '.jpg'];
    saveas(gcf,filename);
    close(gcf);
end