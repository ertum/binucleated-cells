clc; clear; close all;

annotated_image_path = '../../../data/initial_examples/Worst quality images/01 membrane and DNA, annotated.tif';
membrane_image_path = '../../../data/initial_examples/Worst quality images/01 cell membrane.tif';
nuclei_image_path = '../../../data/initial_examples/Worst quality images/01 DNA.tif';

annotated_image = imread(annotated_image_path);
nuclei_image = imread(nuclei_image_path);

[equalized_nuclei_image, filled_nuclei_image, cleaned_nuclei_image] = process_nuclei_image(nuclei_image_path);

[cleaned_image, connected_components, perimeters] = compute_cell_cavities(membrane_image_path);
[ones_points, twos_points, threes_points] = extract_annotation_locations(annotated_image_path);

overlayed = imoverlay(annotated_image, perimeters, [1, 1, 1]);

cell_centroids = get_centroids(regionprops(connected_components, 'Centroid'));

[features, labels, dataset] = get_labeled_data(annotated_image_path, membrane_image_path, nuclei_image_path, false);


%% Draw Labels
figure;
imshow(overlayed);
hold on;

indices = find(labels == 1);
ones_centroids = cell_centroids(indices, :);

plot(ones_centroids(:, 1), ones_centroids(:, 2), 'y*');

indices = find(labels == 2);
twos_centroids = cell_centroids(indices, :);

plot(twos_centroids(:, 1), twos_centroids(:, 2), 'm*');

legend('Ones', 'Twos');
