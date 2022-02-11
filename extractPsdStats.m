function features = extractPsdStats(psd)
% extractPsdStats extract descriptive statistics from the PSD
%
%   features = extractHarmonicFeatures(psd, nHarmonics) extracts features from
%   the power spectral density, psd. psd is a one-sided power spectral density
%   magnitude, i.e. abs(fft(X).^2). features is a table of the extracted 
%   features.
%
%   The extracted statistics are:
%       'MeanPsd'       - The mean of the PSD
%       'StdPsd'        - The standard deviation of the PSD
%       'MedianPsd'     - The median of the PSD
%       'MadPsd'        - The median absolute deviation of the PSD
%       'SkewnessPsd'   - Zero-mean skewness of the PSD   
%       'KurtosisPsd'   - Zero-mean kurtosis of the PSD     

% SPDX-License-Identifier: BSD-3-Clause

%#codegen

features = zeros(1,6, 'like', psd);

avgPsd = mean(psd, 2);
stdPsd = stddev(psd, avgPsd);
medianPsd = codegenMedian(psd);
madPsd = medianAbsDeviation(psd);
skewnessPsd = codegenSkewness(psd);
skewnessPsd = skewnessPsd;
kurtosisPsd = codegenKurtosis(psd);
kurtosisPsd = kurtosisPsd;


features(1) = avgPsd;
features(2) = stdPsd;
features(3) = medianPsd;
features(4) = madPsd;
features(5) = skewnessPsd;
features(6) = kurtosisPsd;
% features = [avgPsd, stdPsd, medianPsd, madPsd, skewnessPsd, kurtosisPsd];
% features.MeanPsd = avg_psd;
% features.StdPsd = std_psd;
% features.MedianPsd = median_psd;
% features.MadPsd = mad_psd;
% features.SkewnessPsd = skew_psd;
% features.KurtosisPsd = kurtosis_psd;

end