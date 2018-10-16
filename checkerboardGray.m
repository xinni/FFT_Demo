numsquares = [64, 64]; %rows columns
squaresize = 1;
pattern = rand([numsquares, 1]);
checkerboard = imresize(pattern, squaresize, 'nearest');
imshow(checkerboard);
filename='randBoard.jpg';
% saveas(gcf,filename);
K = medfilt2(checkerboard);
figure, imshow(K);
