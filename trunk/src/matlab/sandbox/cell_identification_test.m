clc; clear; close all;

gaussianFilter = fspecial('gaussian', [10, 10], 10);

dna_image = imread('../../../data/initial_examples/Best quality images/01 membrane and DNA, annotated.tif');

initial_image = imread('../../../data/initial_examples/Best quality images/01 cell membrane.tif');
blurred_initial = imfilter(initial_image, gaussianFilter, 'symmetric', 'conv');

equalized_image = histeq(blurred_initial);

black_and_white = im2bw(equalized_image, graythresh(equalized_image));

% perform blurring to smooth image
blurred = imfilter(black_and_white, gaussianFilter, 'symmetric', 'conv');

inverted_image = 1 - blurred; 

% flood fill holes
filled_image = imfill(inverted_image,'holes');

filled_image = imopen(filled_image, strel('disk', 6));

% remove small connected components fewer than pixels
min_num_pixels = 500;
cleaned_image = bwareaopen(filled_image, min_num_pixels);

max_num_pixels = 2 * (1e4);
cleaned_image = bwareaclose(cleaned_image, max_num_pixels);


% obtain perimeters
perimeters = bwperim(cleaned_image);

% overlay perimeters on original image
overlayed = imoverlay(dna_image, perimeters, [1, 1, 1]);

connected_components = bwconncomp(cleaned_image);
labels = labelmatrix(connected_components);

rgb_labels = label2rgb(labels);

subplot(2, 2, 1);
imshow(initial_image);
title('initial image');

subplot(2, 2, 2);
imshow(blurred);
title('blurred');

subplot(2, 2, 3);
imshow(cleaned_image);
title('cleaned');

subplot(2, 2, 4);
imshow(rgb_labels);
title('cleaned and inverted');

figure;
imshow(overlayed);
