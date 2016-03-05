function mask = SubtractDominantMotion(image1, image2)
    M = LucasKanadeAffine(image1, image2);
    [m,n] = size(image2);

    img1Corners = [1,1,1;n,1,1;1,m,1;n,m,1];
    img1CornerTransform = (M*img1Corners')';
    min_y = ceil(min(img1CornerTransform(:,1)))+2;
    max_y = floor(max(img1CornerTransform(:,1)))-2;
    min_x = ceil(min(img1CornerTransform(:,2)))+2;
    max_x = floor(max(img1CornerTransform(:,2)))-2;

    warped_image1 = medfilt2(warpH(image1, M, [m, n]));
    delta_image = medfilt2(abs(image2 - warped_image1));
    %histogram(delta_image(:))

    mask = medfilt2(double(delta_image > 25 & delta_image < 256));
    X = (1:m)'*ones(1,n);
    X = X > min_x & X < max_x;
    Y = ones(1,m)'*(1:n);
    Y = Y > min_y & Y < max_y;
    mask = mask .* X .* Y;
    
    se = strel('disk', 8);
    %mask = bwareaopen(mask, 5);
    mask = imdilate(mask, se);
    %mask = imerode(mask, se);
    %mask = medfilt2(mask);
    %mask = double(mask);
    
    %imagesc(mask);
end
