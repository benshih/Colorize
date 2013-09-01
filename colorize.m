% 15-463: Assignment 1, starter Matlab code

% name of the input file
imname = 'C:\Users\BenShih\BenFiles\Fall2013CMU\15862CompPhoto\Project1ColorizationByChannels\data\00106v.jpg';

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

% 9/1 - Naive implementation: simply add the pictures together




% open figure
%% figure(1);

% create a color image (3D array)
% ... use the "cat" command
% show the resulting image
% ... use the "imshow" command
% save result image
%% imwrite(colorim,['result-' imname]);