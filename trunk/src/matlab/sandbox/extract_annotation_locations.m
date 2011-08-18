function [ones_points, twos_points, threes_points] = extract_annotation_locations(annotated_membrane_image)

    combined_image = imread(annotated_membrane_image);

    %% Extract 1's

    [r, c] = find(combined_image(:, :, 3) .* (1 - combined_image(:, :, 2)) >= 1);

    ones_filter = zeros(size(combined_image, 1), size(combined_image, 2));

    for i = 1:length(r)
        ones_filter(r(i), c(i)) = 1;
    end

    ones_filter = imopen(ones_filter, strel('disk', 1));

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

    connected_components = bwconncomp(twos_filter);
    twos_points = regionprops(connected_components, 'Centroid');
    twos_points = get_centroids(twos_points);

    %% Extract 3's

    green_layer = combined_image(:, :, 2);
    green_without_twos = double(green_layer) - (255 * double(twos_filter));

    [r, c] = find(green_without_twos >= 255);

    threes_filter = zeros(size(combined_image, 1), size(combined_image, 2));

    for i = 1:length(r)
        threes_filter(r(i), c(i)) = 1;
    end

    threes_filter = imopen(threes_filter, strel('disk', 1));

    connected_components = bwconncomp(threes_filter);
    threes_points = regionprops(connected_components, 'Centroid');
    threes_points = get_centroids(threes_points);
    
end