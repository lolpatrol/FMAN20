function features = segment2features(I)

% Feature vector
features = zeros(9,1);

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
% (Or just directly add length(row) or length(col))
for i = 1:m
    for j = 1:n
        features(1) = features(1) + region(i,j);
    end
end

% "Holes" in the region, or white parts encircled by black parts
features(2) =  bweuler(region);

% Skewness of region (mean)
features(3) = mean2(moment(region,3));

% Passing a line horizontally at k places
k = 5;
indexes_row = floor(linspace(1, m, k));
lines = 0;
for i = 1:length(indexes_row)
    temp = find(diff(region(i,:)) == 1) - find(diff(region(i,:)) == -1);
    lines_crossed = sum(temp >= 1) + 1;
    lines = lines + lines_crossed;
end
features(4) = lines;

% Passing a line vertically at k places
indexes_col = floor(linspace(1, n, k));
lines = 0;
for i = i:length(indexes_col)
    temp = find(diff(region(:,i)) == 1) - find(diff(region(:,i)) == -1);
    lines_crossed = sum(temp >= 1) + 1;
    lines = lines + lines_crossed;
end
features(5) = lines;

% Difference in sum of left/right part of region
features(6) = sum(sum(region(:, 1:floor(n/2))))...
    -sum(sum(region(:, floor(n/2):n)));
% Difference in sum of upper/lower part of region
features(7) = sum(sum(region(1:floor(m/2), :)))...
    -sum(sum(region(floor(m/2):m, :)));

% Fill encircled segments of the region
% sum each variant and return quotient
% == pixel sum + encircled space / pixel sum
filled_logical = regionprops(region, 'FilledImage');
filled = cell2mat(struct2cell(filled_logical));
features(8) = sum(sum(filled))/sum(sum(region));

% Geometric center of letter in region
centroids = regionprops(region, 'centroid');
features(9) = centroids.Centroid(1)+centroids.Centroid(2);
end
