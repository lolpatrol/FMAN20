function y = features2class(x, classification_data)
%y = predict(classification_data, x');
    
% Number of neighbors, try something higher than 1, if you
% want to crash the program. Let's call it a "feature" for the moment.
k = 7;

% Get the training data
letters = classification_data{1};

% Prepare the image like we did in training
mu = classification_data{2};
sigma = classification_data{3};
x1 = (x-mu)/sigma;

% Calculate the distances
letter_distances = cell(1, 26);
max_length = 0;
for i = 1:size(letters, 2)
    for j = 1:size(letters{i}, 2)
        letter_list = letters{i};
        current = letter_list(:,j);
        dist = norm(current-x1);
        letter_distances{i} = [letter_distances{i} dist];
    end
    if length(letter_distances{i}) < max_length
        max_length = length(letter_distances{i});
    end
end

% Sort the distances (now obsolete)
sorted_distances = zeros(26, max_length);
sorted_distances(:,:) = Inf;
for i = 1:size(letter_distances, 2)
    [sorted, ~] = sort(letter_distances{i});
    sorted_distances(i, 1:length(sorted)) = sorted(:);
end

% find neighbors
found = 0;
idx = zeros(1, 26); % Letter count array for voting
while found < k
    mins = ones(1, 26);
    add = 0;
    for i = 1:26
        letter = letter_distances{i};
        index = find(letter == min(letter));
        if (letter(index) ~= Inf)
            if (length(index) > 1)
                index = index(1);
            end
            mins(i) = letter(index);
            letter_distances{i}(index) = Inf;
            add = 1;
        end
    end
    class_index = find(mins == min(mins));
    idx(class_index) = idx(class_index) + add;
    found = found + add;
end
y = find(idx == max(idx))
end
