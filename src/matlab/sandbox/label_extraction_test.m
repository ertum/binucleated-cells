clc; clear; close all;


combined_image = imread('../../../data/initial_examples/Best quality images/01 membrane and DNA, annotated.tif');

figure;
imshow(combined_image);
title('Original');

%% Extract 1's

[r, c] = find(combined_image(:, :, 3) .* (1 - combined_image(:, :, 2)) >= 1);

ones_filter = zeros(size(combined_image, 1), size(combined_image, 2));

for i = 1:length(r)
    ones_filter(r(i), c(i)) = 1;
end

ones_filter = imopen(ones_filter, strel('disk', 1));

figure;
imshow(ones_filter);
title('Ones Extraction');

connected_components = bwconncomp(ones_filter);
labels = labelmatrix(connected_components);
rgb_labels = label2rgb(labels);

connected_components = bwconncomp(ones_filter);
ones_points = regionprops(connected_components, 'Centroid');
ones_points = get_centroids(ones_points);

%% Extract 2's

[r, c] = find(combined_image(:, :, 3) .* combined_image(:, :, 2) >= 1);

twos_filter = zeros(size(combined_image, 1), size(combined_image, 2));

for i = 1:length(r)
    twos_filter(r(i), c(i)) = 1;
end

twos_filter = imopen(twos_filter, strel('disk', 1));

figure;
imshow(twos_filter);
title('Twos Extraction');


%% Extract 3's

green_layer = combined_image(:, :, 2);
green_without_twos = double(green_layer) - (255 * double(twos_filter));

[r, c] = find(green_without_twos >= 255);

threes_filter = zeros(size(combined_image, 1), size(combined_image, 2));

for i = 1:length(r)
    threes_filter(r(i), c(i)) = 1;
end

threes_filter = imopen(threes_filter, strel('disk', 1));

figure;
imshow(threes_filter);
title('Threes Extraction');


