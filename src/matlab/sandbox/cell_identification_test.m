clc; clear; close all;

gaussianFilter = fspecial('gaussian', [10, 10], 10);

initial_image = imread('../../../data/initial_examples/Best quality images/01 cell membrane.tif');
blurred_initial = imfilter(initial_image, gaussianFilter, 'symmetric', 'conv');

equalized_image = histeq(blurred_initial);

black_and_white = im2bw(equalized_image, graythresh(equalized_image));

% perform blurring to smooth image
blurred = imfilter(black_and_white, gaussianFilter, 'symmetric', 'conv');

inverted_image = 1 - blurred; 

% flood fill holes
filled_image = imfill(inverted_image,'holes');
filled_image = imopen(filled_image, ones(5,5));

% remove small connected components fewer than pixels
min_num_pixels = 900;
cleaned_image = bwareaopen(filled_image, min_num_pixels);

% obtain perimeters
perimeters = bwperim(cleaned_image);

% overlay perimeters on original image
overlayed = imoverlay(initial_image, perimeters, [1, 0, 0]);

subplot(2, 2, 1);
imshow(initial_image);
title('initial image');

subplot(2, 2, 2);
imshow(black_and_white);
title('thresholded');

subplot(2, 2, 3);
imshow(blurred);
title('blurred');

subplot(2, 2, 4);
imshow(filled_image);
title('cleaned and inverted');

figure;
imshow(overlayed);
