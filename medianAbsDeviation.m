function y = medianAbsDeviation(x)
% medianAbsDeviation compute the median absolute deviation

xMedian = median(x, 2);
deviationsFromMedian = abs(x - xMedian);
y = median(deviationsFromMedian, 2);