function features = extractHarmonicFeatures(psd, nHarmonics)
% extractHarmonicFeatures extract features related to harmonics in the PSD.
%
%   features = extractHarmonicFeatures(psd, nHarmonics) extracts features from
%   the power spectral density, psd, for nHarmonics harmonics. psd is a
%   one-sided power spectral density magnitude, i.e. abs(fft(X).^2). 
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

% TODO: make nBins an input parameter

nBins = 2;
nRows = size(psd,1);


harmonicCombinations = [1 2; 1 3; 2 3];
% harmonicCombinations = nchoosek(1:nHarmonics, 2);
nHarmonicCombinations = size(harmonicCombinations, 1);

harmonicHeight = zeros(nRows, nHarmonics, 'like', psd);
harmonicLoc = zeros(nRows, nHarmonics, 'like', psd);
harmonicWidth = zeros(nRows, nHarmonics, 'like', psd);
harmonicProminence = zeros(nRows, nHarmonics, 'like', psd);
harmonicHeightRatio = zeros(nRows, nHarmonicCombinations, 'like', psd);
harmonicWidthRatio = zeros(nRows, nHarmonicCombinations, 'like', psd);
harmonicProminenceRatio = zeros(nRows, nHarmonicCombinations, 'like', psd);

fundamental = estimateFundamentalFreq(psd);

for i = 1:nRows
    % Get features for all peaks
    [peakHeight, peakLoc, peakWidth, peakProminence] = findPeaks(psd(i,:));

    % Compute how close the each peaks' frequency bin is to being an integer
    % multiple of the fundamental frequency.
    % TODO: I think this could be done with rem()
    freqBinDiffs = peakLoc/fundamental(i) - fix(peakLoc/fundamental(i));

    % Find the peak locations that are within nBins of an integer multiple of
    % the fundamental frequency.
    tmp = find(1 - freqBinDiffs <= nBins/fundamental(i) | freqBinDiffs <= nBins/fundamental(i));
    
    % Grab the peaks that are harmonics of the fundamental; if there are less
    % than nHarmonics, the missing harmonics are set as NaN.
    if numel(tmp) >= 3
        harmonicLoc(i,:) = peakLoc(tmp(1:nHarmonics));
        harmonicWidth(i,:) = peakWidth(tmp(1:nHarmonics));
        harmonicProminence(i,:) = peakProminence(tmp(1:nHarmonics));
        harmonicHeight(i,:) = peakHeight(tmp(1:nHarmonics));
    else
        harmonicLoc(i,1:numel(tmp)) = peakLoc(tmp);
        harmonicWidth(i,1:numel(tmp)) = peakWidth(tmp);
        harmonicProminence(i,1:numel(tmp)) = peakProminence(tmp);
        harmonicHeight(i,1:numel(tmp)) = peakHeight(tmp);
    end
    
    % Compute feature ratios for all n-choose-2 combinations of harmonics
    for n = 1:nHarmonicCombinations
        % Get the harmonic numbers we are taking a ratio of
        harmonic1 = harmonicCombinations(n, 1);
        harmonic2 = harmonicCombinations(n, 2);

        if harmonicHeight(i, harmonic2) ~= 0
            harmonicHeightRatio(i, n) = harmonicHeight(i, harmonic1) / harmonicHeight(i, harmonic2);
        else
            harmonicHeightRatio(i, n) = 0;
        end

        if harmonicWidth(i, harmonic2) ~= 0
            harmonicWidthRatio(i, n) = harmonicWidth(i ,harmonic1) / harmonicWidth(i, harmonic2);
        else
            harmonicWidthRatio(i, n) = 0;
        end

        if harmonicProminence(i, harmonic2) ~= 0
            harmonicProminenceRatio(i, n) = harmonicProminence(i ,harmonic1) / harmonicProminence(i, harmonic2);
        else
            harmonicProminenceRatio(i, n) = 0;
        end
    end
end

% Assemble features into our output table
% TODO: don't hardcode 21
features = zeros(size(psd,1), 21, 'like', psd);

features(:,1) = harmonicHeight(:, 1);
features(:,2) = harmonicLoc(:, 1);
features(:,3) = harmonicWidth(:, 1);
features(:,4) = harmonicProminence(:, 1);
features(:,5) = harmonicHeight(:, 2);
features(:,6) = harmonicLoc(:, 2);
features(:,7) = harmonicWidth(:, 2);
features(:,8) = harmonicProminence(:, 2);
features(:,9) = harmonicHeight(:, 3);
features(:,10) = harmonicLoc(:, 3);
features(:,11) = harmonicWidth(:, 3);
features(:,12) = harmonicProminence(:, 3);
features(:,13) = harmonicHeightRatio(:, 1);
features(:,14) = harmonicWidthRatio(:, 1);
features(:,15) = harmonicProminenceRatio(:, 1);
features(:,16) = harmonicHeightRatio(:, 2);
features(:,17) = harmonicWidthRatio(:, 2);
features(:,18) = harmonicProminenceRatio(:, 2);
features(:,19) = harmonicHeightRatio(:, 3);
features(:,20) = harmonicWidthRatio(:, 3);
features(:,21) = harmonicProminenceRatio(:, 3);

% for n = 1:nHarmonics
%     features(:,1 + 4*(n-1)) = harmonicHeight(:, n);
%     features(:,2 + 4*(n-1)) = harmonicLoc(:, n);
%     features(:,3 + 4*(n-1)) = harmonicWidth(:, n);
%     features(:,4 + 4*(n-1)) = harmonicProminence(:, n);
% end

% for n = 1:nHarmonicCombinations
%     features(:,13 + 4*(n-1)) = harmonicHeightRatio(:, n);
%     features(:,14 + 4*(n-1)) = harmonicWidthRatio(:, n);
%     features(:,15 + 4*(n-1)) = harmonicProminenceRatio(:, n);
% end
end