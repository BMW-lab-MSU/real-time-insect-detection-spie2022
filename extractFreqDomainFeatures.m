function features = extractFreqDomainFeatures(X)
% extractFreqDomainFeatures extract frequency-domain features for insect
% detection
%
%   features = extractFreqDomainFeatures(X) extracts features from the data   %   matrix, X, and returns the features as a table. Observations are rows in X.
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


NUM_FREQ_FEATURES = 27;
features = zeros(size(X,1), NUM_FREQ_FEATURES, 'like', X);
nHarmonics = 3;

esd = zeros(size(X));
oneSidedEsd = zeros(size(X,1), size(X,2)/2);

ft = dsp.FFT('FFTLengthSource', 'Property', 'FFTLength', size(X,2));

% dsp.FFT works on columns, so I have to transpose so the observations
% are in columns and then transpose back so they are in rows again.
spectrum = ft(X')';
esd = real(spectrum).^2 + imag(spectrum).^2;

% Only look at the positive frequencies
oneSidedEsd = esd(:,1:end/2);

% Normalize by the DC component
oneSidedEsd = oneSidedEsd./oneSidedEsd(:,1);

features(:,1:6) = extractPsdStats(oneSidedEsd);
features(:,7:NUM_FREQ_FEATURES) = extractHarmonicFeatures(oneSidedEsd, nHarmonics);

end