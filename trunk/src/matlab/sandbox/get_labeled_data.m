function [training, group, dataset] = get_labeled_data(annotated_image_path, membrane_image_path, nuclei_image_path, force_two_labels)

    annotated_image = imread(annotated_image_path);
    nuclei_image = imread(nuclei_image_path);

    [equalized_nuclei_image, filled_nuclei_image, cleaned_nuclei_image] = process_nuclei_image(nuclei_image_path);

    [cleaned_image, connected_components, perimeters] = compute_cell_cavities(membrane_image_path);
    [ones_points, twos_points, threes_points] = extract_annotation_locations(annotated_image_path);

    overlayed = imoverlay(annotated_image, perimeters, [1, 1, 1]);


    cell_centroids = get_centroids(regionprops(connected_components, 'Centroid'));

    patches = regionprops(connected_components, 'Image');
    bounding_boxes = regionprops(connected_components, 'BoundingBox');
    pixels = regionprops(connected_components, 'PixelList');

    dataset_index = 1;
    
    patch_width = 50;
    patch_height = 50;

    for component_index = 1:size(cell_centroids, 1);
        cell_centroid = cell_centroids(component_index, :);

        min_distance = 1e10;
        min_index = 0;
        min_label = 0;

        for j = 1:size(ones_points, 1)
            point = ones_points(j, :);
            distance = sqrt(sum(sum((cell_centroid - point).^2)));
            if (distance < min_distance)
                min_index = j;
                min_label = 1;
                min_distance = distance;
            end
        end

        for j = 1:size(twos_points, 1)
            point = twos_points(j, :);
            distance = sqrt(sum(sum((cell_centroid - point).^2)));
            if (distance < min_distance)
                min_index = j;
                min_label = 2;
                min_distance = distance;
            end
        end

        for j = 1:size(threes_points, 1)
            point = threes_points(j, :);
            distance = sqrt(sum(sum((cell_centroid - point).^2)));
            if (distance < min_distance)
                min_index = j;
                min_label = 3;
                min_distance = distance;
            end
        end

        if (min_distance > 60)
            min_label = 0;
        end

        connected_components.labels(component_index) = min_label;
        x = floor(cell_centroid);

        if (force_two_labels && min_label == 3)
            min_label = 2;
        end

        if (~force_two_labels || (min_label > 0))

            datum.label = min_label;

            bounding_box = bounding_boxes(component_index).BoundingBox;

            temp_image = equalized_nuclei_image;

            pixel_list = pixels(component_index).PixelList;
            mask = uint8(zeros(size(temp_image, 1), size(temp_image, 2)));

            for l = 1:size(pixel_list, 1)
                mask(pixel_list(l, 2), pixel_list(l, 1)) = 1;
            end


            temp_image = temp_image .* mask;

            subimage = get_subimage(temp_image, bounding_box, 5);
            subimage = imresize(subimage, [patch_height, patch_width]);
            datum.patch = subimage;

            dataset(dataset_index) = datum;
            dataset_index = dataset_index  + 1;
        end
    end

    training = zeros(length(dataset), patch_height * patch_width);
    group = zeros(length(dataset), 1);
    
    for i = 1:length(dataset)
        patch = dataset(i).patch;
        label = dataset(i).label;
        
        training(i, :) = reshape(patch, 1, patch_height * patch_width);
        group(i) = label;
    end
end
