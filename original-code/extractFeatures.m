function features = extractFeatures(X, opts)
% extractFeatures extract features for insect detection
%
%   features = extractFeatures(X) extracts features from the data matrix, X,
%   and returns the features as a table. Observations are rows in X.
%
%   The extracted time-domain features are:
%       'RowMeanMinusImageMean' - The mean of the obvservation minus the mean
%                                 of the entire image
%       'StdDev'                - The standard deviation of each row
%       'MaxDiff'               - The maximum absolute first difference in a row
%
%   The extracted PSD statistics are:
%       'MeanPsd'                   - The mean of the PSD
%       'StdPsd'                    - The standard deviation of the PSD
%       'MedianPsd'                 - The median of the PSD
%       'MadPsd'                    - The median absolute deviation of the PSD
%       'SkewnessPsd'               - Zero-mean skewness of the PSD   
%       'KurtosisPsd'               - Zero-mean kurtosis of the PSD     
%       
%   The extracted features for each harmonic are:
%       'HarmonicHeight'            - The height of the harmonic
%       'HarmonicLoc'               - The harmonic location (frequency bin)
%       'HarmonicWidth'             - The harmonic's half-prominence peak width
%       'HarmonicProminence'        - The harmonic's prominence
%
%   The extracted features for all combinations of n-choose-2 harmonics are:
%       'HarmonicHeightRatio'       - The ratio between harmonic heights
%       'HarmonicWidthRatio'        - The ratio between harmonic widths
%       'HarmonicProminenceRatio'   - The ratio between harmonic prominences

% SPDX-License-Identifier: BSD-3-Clause

arguments
    X (:,:) {mustBeNumeric}
    opts.UseParallel (1,1) logical = false
end

timeFeatures = extractTimeDomainFeatures(X);
freqFeatures = extractFreqDomainFeatures(X, 'UseParallel', opts.UseParallel);

features = [timeFeatures, freqFeatures];
end
