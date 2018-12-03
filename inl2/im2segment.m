 function [S] = im2segment(im)
% [S] = im2segment(im)

% Dimensions of image
[m, n] = size(im);

% Matrix for quantized image
ones_and_zeros = zeros(m, n);

% Matrix for grouping segments
components = zeros(m, n);

% Find threshold to differentiate between black and white
limit = multithresh(im,1); % 2^1 bins

% Set values according to the limit.
ones_and_zeros = im <= limit; %128+11 as limit gives Jaccard 1.0

% Get connected components in the image
components = bwlabel(ones_and_zeros);

% Get number of connected components
max_val = max(components(:));

% Extract the components into new images (segments)
for i = 1:max_val
    segment = zeros(m, n); % Blank image
    % Get coordinates for the connected component
    [rows, cols] = find(components == i);
    for j = 1:size(rows)
        % Set the corresponding coordinate to 1 in the segment
        segment(rows(j), cols(j)) = 1;
    end
    % Add it to the cell array
    S{i} = segment;
end

end
