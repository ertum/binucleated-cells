function subimage = get_subimage(image, bounding_box, extension_factor)
    x_start = ceil(bounding_box(1)) - extension_factor;
    y_start = ceil(bounding_box(2)) - extension_factor;
    x_end = floor(bounding_box(1) + bounding_box(3)) + extension_factor;
    y_end = floor(bounding_box(2) + bounding_box(4)) + extension_factor;
    
    if (x_start < 1)
        x_start = 1;
    end
    
    if (y_start < 1)
        y_start = 1;
    end
    
    if (x_end > size(image, 2))
        x_end = size(image, 2);
    end
    
    if (y_end > size(image, 1))
        y_end = size(image, 1);
    end
    
    subimage = image(y_start:y_end, x_start:x_end, :);
end