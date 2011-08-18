function centroids = get_centroids(region_properties)
    centroids = zeros(size(region_properties, 1), 2);
    
    for i = 1:size(region_properties, 1)
        element = region_properties(i);
        centroids(i, :) = element.Centroid;
    end
end