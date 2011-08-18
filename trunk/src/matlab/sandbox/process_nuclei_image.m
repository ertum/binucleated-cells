function [equalized_image, filled_image, cleaned_image] = process_nuclei_image(nuclei_image_path)
    gaussianFilter = fspecial('gaussian', [2, 2], 2);
    gaussianFilter2 = fspecial('gaussian', [10, 10], 10);

    initial_image = imread(nuclei_image_path);
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
end