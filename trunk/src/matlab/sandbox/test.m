clc; clear; close all;

I = imread('01 cell membrane.tif');
I2 = adapthisteq(I);
bw = im2bw(I2, graythresh(I2));

gaussianFilter = fspecial('gaussian', [7, 7], 5);

blurred = 1 - imfilter(bw, gaussianFilter, 'symmetric', 'conv');

p = imfill(blurred,'holes');
bw3 = imopen(p, ones(5,5));
bw4 = bwareaopen(bw3, 40);
p = bwperim(bw4);

overlayed = imoverlay(I, p, [1, 0, 0]);

subplot(2, 2, 1);
imshow(I);

subplot(2, 2, 2);
imshow(bw);

subplot(2, 2, 3);
imshow(blurred);

subplot(2, 2, 4);
imshow(bw4);

figure;
imshow(overlayed);