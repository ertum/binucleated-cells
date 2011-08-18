function [cleaned_image, connected_components, perimeters] = compute_cell_cavities(membrane_image_path)
    gaussianFilter = fspecial('gaussian', [10, 10], 10);

    initial_image = imread(membrane_image_path);
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

    connected_components = bwconncomp(cleaned_image);
end