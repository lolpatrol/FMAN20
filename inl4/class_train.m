function classification_data = class_train(X, Y)
% Train function.

[m, n] = size(X);

letters = cell(1, max(Y));
[z_scores, mu, sigma] = zscore(X);
for i = 1:n
    letter_num = Y(i);
    letters{letter_num} = [letters{letter_num} z_scores(:, i)]; 
end

classification_data = cell(1, 3);
classification_data{1} = letters;
classification_data{2} = mu;
classification_data{3} = sigma;
end

