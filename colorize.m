% 15-463: Assignment 1, starter Matlab code

close all
clear all

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



%% 9/2 - Naive implementation for L2 norm ("Sum of Squared Differences (SSD)")

% Search over a window of possible displacements.
xdisplace = -15:15;
ydisplace = -15:15;

%% Create the affine transformation matrix (in this case, it is a translation in x by tx and translation in y by ty).

L2normG = zeros(length(xdisplace)*length(ydisplace), 3); % third dimension is for storing the metric value
L2normR = zeros(length(xdisplace)*length(ydisplace), 3); % third dimension is for storing the metric value

for i = 1:length(xdisplace)
    for j = 1:length(ydisplace)
        
        % Alignment for G.
        txG = xdisplace(i);
        tyG = ydisplace(j);
        Gt = maketform('affine', [1 0 0; 0 1 0; txG tyG 1]); 
        Gshift = imtransform(G, Gt, 'XData', [1 size(G, 2)], 'YData', [1 size(G, 1)]);
        
        row = (i-1)*length(xdisplace)+j;
        L2normG(row, 1) = i;
        L2normG(row, 2) = j;
        L2normG(row, 3) = sum(sum((B-Gshift).^2));
        
        % Alignment for R.
        
        txR = xdisplace(i);
        tyR = ydisplace(j);
        Rt = maketform('affine', [1 0 0; 0 1 0; txR tyR 1]); 
        Rshift = imtransform(R, Rt, 'XData', [1 size(R, 2)], 'YData', [1 size(R, 1)]);
        
        row = (i-1)*length(xdisplace)+j;
        L2normR(row, 1) = i;
        L2normR(row, 2) = j;
        L2normR(row, 3) = sum(sum((B-Rshift).^2));
    end
end

% Find the shift corresponding to the minimum distance and make the shift.
[minG, indx] = min(L2normG(:, 3));
xshiftG = xdisplace(L2normG(indx, 1));
yshiftG = ydisplace(L2normG(indx, 2));

Gt = maketform('affine', [1 0 0; 0 1 0; xshiftG yshiftG 1]);
Gshift = imtransform(G, Gt, 'XData', [1 size(G, 2)], 'YData', [1 size(G, 1)]);


% Find the shift corresponding to the minimum distance and make the shift.
[minR, indx] = min(L2normR(:, 3));
xshiftR = xdisplace(L2normR(indx, 1));
yshiftR = ydisplace(L2normR(indx, 2));

Rt = maketform('affine', [1 0 0; 0 1 0; xshiftR yshiftR 1]);
Rshift = imtransform(R, Rt, 'XData', [1 size(R, 2)], 'YData', [1 size(R, 1)]);


%% 9/1 - Naive implementation: simply add the pictures together.

aggImg = cat(3, Rshift, Gshift, B);
imshow(aggImg)

xshiftG
yshiftG
xshiftR
yshiftR


%% TODO - Normal cross correlation
% http://www.mathworks.com/help/images/examples/registering-an-image-using-normalized-cross-correlation.html




%%

% this command is a decent approximation for the shed image:
% figure; Gshift = circshift(G, [4, -1]);Rshift = circshift(R, [12, 0]);aggImg = cat(3, Rshift, Gshift, B); imshow(aggImg)

% open figure
%% figure(1);

% create a color image (3D array)
% ... use the "cat" command
% show the resulting image
% ... use the "imshow" command
% save result image
%% imwrite(colorim,['result-' imname]);
