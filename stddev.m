function s = stddev(x, avg)

normalization = size(x,2) - 1;

partial1 = abs(x - avg).^2;
partial2 = sum(partial1, 2);
partial3 = partial2 / normalization;
s = sqrt(partial3);
% s = sqrt(sum(abs(x - mean(x,2)).^2, 2) ./ (size(x,2)-1));
