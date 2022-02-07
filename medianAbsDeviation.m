function y = medianAbsDeviation(x)
% medianAbsDeviation compute the median absolute deviation

%#codegen

xMedian = median(x, 2);

difference = x - xMedian;

deviationsFromMedian = sign(difference) .* difference;

y = median(deviationsFromMedian, 2);