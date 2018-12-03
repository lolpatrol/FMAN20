function features = segment2features(I)

% Feature vector
features = zeros(36,1);

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

% HC SVNT DRACONES - New and rewritten things for assignment 4

mid_x = floor(n/2);
mid_y = floor(m/2);

% Left and right side
if mod(n, 2) > 0
    left = region(:, 1:mid_x+1);
    right = region(:, mid_x+1:n);
else
    left = region(:, 1:mid_x);
    right = region(:, mid_x+1:n);
end

features(10) = sum(sum(left-right));
features(11) = sum(sum(abs(left-right)));
features(12) = mean(sum(left-right));
features(13) = mean(sum(left-right,2));
features(14) = var(sum(left-right));
features(15) = var(sum(left-right,2));

% Put left and right side on top of each other
diff_lr = left+right;
diff_lr = diff_lr > 0; % Scale to [0,1]
[newM, newN] = size(diff_lr);
newMidY = floor(newM/2);

% Cut that in the middle
if mod(newM, 2) > 0
    upper = region(1:newMidY+1, :);
    lower = region(newMidY+1:newM, :);
else
    upper = region(1:newMidY, :);
    lower = region(newMidY+1:newM, :);
end

% Save all the things as features
diff_ul = abs(upper-lower);
features(16) = sum(sum(upper-lower));
features(17) = sum(sum(abs(upper-lower)));
features(18) = mean(sum(diff_ul));
features(19) = mean(sum(diff_ul,2));
features(20) = var(sum(diff_ul));
features(21) = var(sum(diff_ul,2));

% Do the same starting in the other direction
if mod(m, 2) > 0
    upper = region(1:mid_y+1,:);
    lower = region(mid_y+1:m,:);
else
    upper = region(1:mid_y,:);
    lower = region(mid_y+1:m,:);
end

features(22) = sum(sum(upper-lower));
features(23) = sum(sum(abs(upper-lower)));
features(24) = mean(sum(upper-lower));
features(25) = mean(sum(upper-lower,2));
features(26) = var(sum(upper-lower));
features(27) = var(sum(upper-lower,2));

diff_ul = upper+lower;
diff_ul = diff_ul > 0;
[newM, newN] = size(diff_ul);
newMidX = floor(newN/2);

if mod(newN, 2) > 0
    left = region(:, 1:newMidX+1);
    right = region(:, newMidX+1:newN);
else
    left = region(:, 1:newMidX);
    right = region(:, newMidX+1:newN);
end

diff_lr = abs(left-right);
features(28) = sum(sum(left-right));
features(29) = sum(sum(diff_lr));
features(30) = mean(sum(diff_lr));
features(31) = mean(sum(diff_lr,2));
features(32) = var(sum(diff_lr));
features(33) = var(sum(diff_lr,2));

[B,L,n,A] = bwboundaries(region);
% Number of objects in the region
features(34) = length(B);
% Count the pixels that are not background or the letter
[m_L, n_L] = size(L);
L_size = m_L*n_L;
el_in_im = L_size - numel(find(L == 1))- numel(find(L == 0));
features(35) = el_in_im;

el_sub_sum = L_size;
for i = 2:length(B)
    el_sub_sum = el_sub_sum - numel(find(L == i))*i;
end
features(36) = el_sub_sum;

end
