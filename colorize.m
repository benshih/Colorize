% 15-463: Assignment 1, starter Matlab code

% name of the input file using relative paths
imname = 'Colorize/00888v.jpg';

% read in the image
fullim = imread(imname);

% convert to double matrix (might want to do this later on to same memory)
fullim = im2double(fullim);

% compute the height of each part (just 1/3 of total)
height = floor(size(fullim,1)/3);
% separate color channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

% Align the images
% Functions that might be useful to you for aligning the images include: 
% "circshift", "sum", and "imresize" (for multiscale)
%%%%%aG = align(G,B);
%%%%%aR = align(R,B);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ben's strategy:
% -normalize
% -cross correlation of both images with b, find maximum of correlation,
% center around that point using simple geo shifting

% 9/2 - Naive implementation for L2 norm ("Sum of Squared Differences
% (SSD)")
Gshift = G;
Rshift = R;

% Create the affine transformation matrix (in this case, it is a
% translation in x by tx and translation in y by ty).
txG = 0;
tyG = 0;
Gt = maketform('affine', [1 0 0; 0 1 0; txG tyG 1]); 
Gshift = imtransform(G, Gt, 'XData', [1 size(G, 2)], 'YData', [1 size(G, 1)]);

txR = 0;
tyR = 0;
Rt = maketform('affine', [1 0 0; 0 1 0; txR tyR 1]);
Rshift = imtransform(R, Rt, 'XData', [1 size(R, 2)], 'YData', [1 size(R, 1)]);


% 9/1 - Naive implementation: simply add the pictures together.

aggImg = cat(3, B, Gshift, Rshift);
imshow(aggImg)




% open figure
%% figure(1);

% create a color image (3D array)
% ... use the "cat" command
% show the resulting image
% ... use the "imshow" command
% save result image
%% imwrite(colorim,['result-' imname]);