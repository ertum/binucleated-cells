clc; clear; close all;

annotated_image_path = '../../../data/initial_examples/Best quality images/01 membrane and DNA, annotated.tif';
membrane_image_path = '../../../data/initial_examples/Best quality images/01 cell membrane.tif';
nuclei_image_path = '../../../data/initial_examples/Best quality images/01 DNA.tif';

annotated_image = imread(annotated_image_path);
nuclei_image = imread(nuclei_image_path);

[features, labels, dataset] = get_labeled_data(annotated_image_path, membrane_image_path, nuclei_image_path, false);

%% Display some random (feature, label) pairs
rows = 5;
cols = 5;

indices = randi(length(dataset), rows * cols, 1);

for i = 1:(rows * cols)
    index = indices(i);
    subplot(rows, cols, i);
    imshow(dataset(index).patch);
    title(sprintf('label = %d', dataset(index).label));
end

