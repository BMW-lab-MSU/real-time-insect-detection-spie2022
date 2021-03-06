function features = extractHarmonicFeatures(psd)
% extractHarmonicFeatures extract features related to harmonics in the PSD.
%
%   features = extractHarmonicFeatures(psd, nHarmonics) extracts features from
%   the power spectral density, psd, for nHarmonics harmonics. psd is a
%   one-sided power spectral density magnitude, i.e. abs(fft(X)).^2. 
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

%#codegen

nBins = 2;
nRows = size(psd,1);

nHarmonics = 3;

harmonicCombinations = [1 2; 1 3; 2 3];
% harmonicCombinations = nchoosek(1:nHarmonics, 2);
nHarmonicCombinations = 3;

harmonicHeight = zeros(size(psd,1), 3, 'like', psd);
harmonicLoc = zeros(size(psd,1), 3, 'like', psd);
harmonicWidth = zeros(size(psd,1), 3, 'like', psd);
harmonicProminence = zeros(size(psd,1), 3, 'like', psd);
harmonicHeightRatio = zeros(size(psd,1), 3, 'like', psd);
harmonicWidthRatio = zeros(size(psd,1), 3, 'like', psd);
harmonicProminenceRatio = zeros(size(psd,1), 3, 'like', psd);

fundamental = estimateFundamentalFreq(psd);

for i = 1:size(psd,1)


    % Get features for all peaks
    [peakHeight, peakLoc, peakWidth, peakProminence] = findPeaks(psd(i,:));

    % Grab the peaks that are harmonics of the fundamental
    [harmonicLoc(i,:), harmonicIdx] = findHarmonics(peakLoc, fundamental(i), nHarmonics);
    
    % Get features for the harmonics. If a harmonic wasn't found, harmonicIdx
    % will be 0. All related features to be 0 if the harmonic wasn't found.
    for j = 1:numel(harmonicIdx)
        if harmonicIdx(j) ~= 0
            harmonicWidth(i,j) = peakWidth(harmonicIdx(j));
            harmonicProminence(i,j) = peakProminence(harmonicIdx(j));
            harmonicHeight(i,j) = peakHeight(harmonicIdx(j));
        end
    end
    
    % Compute feature ratios for all n-choose-2 combinations of harmonics
    for n = 1:3
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
features(:,2) = harmonicHeight(:, 2);
features(:,3) = harmonicHeight(:, 3);
features(:,4) = harmonicWidth(:, 1);
features(:,5) = harmonicWidth(:, 2);
features(:,6) = harmonicWidth(:, 3);
features(:,7) = harmonicProminence(:, 1);
features(:,8) = harmonicProminence(:, 2);
features(:,9) = harmonicProminence(:, 3);
features(:,10) = harmonicHeightRatio(:, 1);
features(:,11) = harmonicHeightRatio(:, 2);
features(:,12) = harmonicHeightRatio(:, 3);
features(:,13) = harmonicWidthRatio(:, 1);
features(:,14) = harmonicWidthRatio(:, 2);
features(:,15) = harmonicWidthRatio(:, 3);
features(:,16) = harmonicProminenceRatio(:, 1);
features(:,17) = harmonicProminenceRatio(:, 2);
features(:,18) = harmonicProminenceRatio(:, 3);
features(:,19) = harmonicLoc(:, 1);
features(:,20) = harmonicLoc(:, 2);
features(:,21) = harmonicLoc(:, 3);

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
