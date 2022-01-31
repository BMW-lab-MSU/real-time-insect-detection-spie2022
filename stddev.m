function s = stddev(x, avg)

s = sqrt(sum(abs(x - mean(x,2)).^2, 2) ./ (size(x,2)-1));
