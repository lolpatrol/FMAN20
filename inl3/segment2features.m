function features = segment2features(I)

% Feature vector
features = zeros(11,1);

% Find region of ones in the segment
[row, col] = find(I == 1);
% Construct a rectangle as delimiter for region
min_col = min(col);
min_row = min(row);
max_col = max(col);
max_row = max(row);
region = I(min_row:max_row, min_col:max_col);
% Dimensions of region
[m, n] = size(region);

% Features

% Sum of pixels in region
features(1) = sum(sum(region));

% "Holes" in the region, or white parts encircled by black parts
features(2) =  bweuler(region);

% mean x
features(3) = mean(sum(region));
% mean y
features(4) = mean(sum(region, 2));
% var x
features(5) = var(sum(region));
% var y
features(6) = var(sum(region, 2));

% Fill encircled segments of the region
% sum each variant and return quotient
% == pixel sum + encircled space / pixel sum
filled_logical = regionprops(region, 'FilledImage');
filled = cell2mat(struct2cell(filled_logical));
features(7) = sum(sum(filled))/sum(sum(region));

% Geometric center of letter in region
stats = regionprops(region, 'centroid');
features(8) = stats.Centroid(1);
features(9) = stats.Centroid(2);

mid_y = floor(m/2);
% catch: V, X, Y, etc.
if mod(m, 2) > 0
    left = region(1:mid_y+1, :);
    right = region(mid_y+1:m, :);
    right = rot90(rot90(right));
    features(10) = sum(sum(left-right));
    %features(16) = mean(sum(region(1:mid_y+1, :)-region(mid_y+1:m, :)));
    %features(17) = mean(sum(region(1:mid_y+1, :)-region(mid_y+1:m, :),2));
    %features(18) = var(sum(region(1:mid_y+1, :)-region(mid_y+1:m, :)));
    %features(19) = var(sum(region(1:mid_y+1, :)-region(mid_y+1:m, :),2));
else
    left = region(1:mid_y, :);
    right = region(mid_y+1:m, :);
    right = rot90(rot90(right));
    features(10) = sum(sum(region(1:mid_y, :)-region(mid_y+1:m, :)));
    %features(16) = mean(sum(region(1:mid_y, :)-region(mid_y+1:m, :)));
    %features(17) = mean(sum(region(1:mid_y, :)-region(mid_y+1:m, :),2));
    %features(18) = var(sum(region(1:mid_y, :)-region(mid_y+1:m, :)));
    %features(19) = var(sum(region(1:mid_y, :)-region(mid_y+1:m, :),2));
end

% catch: J, L, etc.
mid_x = floor(n/2);
if mod(n, 2) > 0
    upper = region(:, 1:mid_x+1);
    lower = region(:, mid_x+1:n);
    lower = rot90(rot90(lower));
    features(11) = sum(sum(upper-lower));
    %features(12) = mean(sum(region(:, 1:mid_x+1)-region(:, mid_x+1:n)));
    %features(13) = mean(sum(region(:, 1:mid_x+1)-region(:, mid_x+1:n),2));
    %features(14) = var(sum(region(:, 1:mid_x+1)-region(:, mid_x+1:n)));
    %features(15) = var(sum(region(:, 1:mid_x+1)-region(:, mid_x+1:n),2));
else
    upper = region(:, 1:mid_x);
    lower = region(:, mid_x+1:n);
    lower = rot90(rot90(lower));
    features(11) = sum(sum(upper-lower));
    %features(12) = mean(sum(region(:, 1:mid_x)-region(:, mid_x+1:n)));
    %features(13) = mean(sum(region(:, 1:mid_x)-region(:, mid_x+1:n),2));
    %features(14) = var(sum(region(:, 1:mid_x)-region(:, mid_x+1:n)));
    %features(15) = var(sum(region(:, 1:mid_x)-region(:, mid_x+1:n),2));
end




end
