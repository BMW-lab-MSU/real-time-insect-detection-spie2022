function y = medianAbsDeviation(x)
% medianAbsDeviation compute the median absolute deviation

%#codegen

xMedian = codegenMedian(x);

difference = x - xMedian;

deviationsFromMedian = sign(difference) .* difference;

y = codegenMedian(deviationsFromMedian);