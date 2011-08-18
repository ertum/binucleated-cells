clc; clear; close all;

annotated_image_path = '../../../data/initial_examples/Best quality images/01 membrane and DNA, annotated.tif';
membrane_image_path = '../../../data/initial_examples/Best quality images/01 cell membrane.tif';
nuclei_image_path = '../../../data/initial_examples/Best quality images/01 DNA.tif';

annotated_image = imread(annotated_image_path);
nuclei_image = imread(nuclei_image_path);

[features, labels, dataset] = get_labeled_data(annotated_image_path, membrane_image_path, nuclei_image_path, true);


%% Classification

N = length(labels);
k = 10;

indices = crossvalind('kfold', labels, k);
cp = classperf(labels);

for i = 1:k
    test = (indices == i);
    train = ~test;
    
    training_features = features(train, :);
    training_labels = labels(train, :);
    test_features = features(test, :);
    
    predicted_labels = knnclassify(test_features, training_features, training_labels);
    
    classperf(cp, predicted_labels, test);
end

cp.ErrorRate
cp.CountingMatrix