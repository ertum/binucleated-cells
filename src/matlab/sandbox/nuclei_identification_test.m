clc; clear; close all;

gaussianFilter = fspecial('gaussian', [2, 2], 2);
gaussianFilter2 = fspecial('gaussian', [10, 10], 10);

combined_image = imread('../../../data/initial_examples/Best quality images/02 membrane and DNA, annotated.tif');

initial_image = imread('../../../data/initial_examples/Best quality images/02 DNA.tif');
blurred_initial = imfilter(initial_image, gaussianFilter, 'symmetric', 'conv');

equalized_image = adapthisteq(blurred_initial);

black_and_white = im2bw(equalized_image * 0.6, graythresh(equalized_image));



% perform blurring to smooth image
blurred = imfilter(black_and_white, gaussianFilter2, 'symmetric', 'conv');


filled_image = blurred;

% flood fill holes
%filled_image = imfill(blurred,'holes');

%filled_image = imopen(filled_image, strel('disk', 2));

% remove small connected components fewer than pixels
min_num_pixels = 40;
cleaned_image = bwareaopen(filled_image, min_num_pixels);

% obtain perimeters
perimeters = bwperim(cleaned_image);

% overlay perimeters on original image
overlayed = imoverlay(combined_image, perimeters, [1, 1, 1]);

connected_components = bwconncomp(filled_image);
labels = labelmatrix(connected_components);

rgb_labels = label2rgb(labels);


subplot(2, 2, 1);
imshow(initial_image);
title('initial image');

subplot(2, 2, 2);
imshow(equalized_image);
title('equalized_image');

subplot(2, 2, 3);
imshow(blurred);
title('blurred');

subplot(2, 2, 4);
imshow(rgb_labels);
title('cleaned and inverted');

figure;
imshow(overlayed);

