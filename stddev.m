function s = stddev(x, avg)

%#codegen

normalization = size(x,2) - 1;

partial1 = (x - avg);
partial2 = real(partial1).^2 + imag(partial1).^2;
partial3 = sum(partial2, 2);
partial4 = partial3 / normalization;
s = sqrt(partial4);
% s = sqrt(sum(abs(x - mean(x,2)).^2, 2) ./ (size(x,2)-1));
