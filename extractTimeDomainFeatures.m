function features = extractTimeDomainFeatures(X)
% extractTimeDomainFeatures extract features from time-domain lidar images for
% insect detection
%
%   features = extractTimeDomainFeatures(X) extracts features from the data
%   matrix, X, and returns the features as a table. Observations are rows in X.
%
%   The extracted features are:
%       'RowMeanMinusImageMean' - The mean of the obvservation minus the mean
%                                 of the entire image
%       'StdDev'                - The standard deviation of each row
%       'MaxDiff'               - The maximum absolute first difference in a row

% SPDX-License-Identifier: BSD-3-Clause

%#codegen

rowMean = mean(X, 2);

rowStd = stddev(X, rowMean);

firstDiff = X(:, 2:end) - X(:, 1:end-1);

absFirstDiff = abs(firstDiff);

maxDiff = max(absFirstDiff, [], 2);

features = [rowMean, rowStd, maxDiff];
% features.RowMeanMinusImageMean = rowMean - imageMean;
% features.StdDev = rowStd;
% features.MaxDiff = maxDiff;
end