function features = extractHarmonicFeatures(psd, nHarmonics, opts)
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
arguments
    psd (:,:) {mustBeNumeric}
    nHarmonics (1,1) double
    opts.UseParallel (1,1) logical = false
end

nBins = 2;
nRows = height(psd);

harmonicCombinations = nchoosek(1:nHarmonics, 2);
nHarmonicCombinations = height(harmonicCombinations);

peakHeight = cell(nRows, 1);
peakLoc = cell(nRows, 1);
peakWidth = cell(nRows, 1);
peakProminence = cell(nRows, 1);

harmonicHeight = nan(nRows, nHarmonics);
harmonicLoc = nan(nRows, nHarmonics);
harmonicWidth = nan(nRows, nHarmonics);
harmonicProminence = nan(nRows, nHarmonics);
harmonicHeightRatio = nan(nRows, nHarmonicCombinations);
harmonicWidthRatio = nan(nRows, nHarmonicCombinations);
harmonicProminenceRatio = nan(nRows, nHarmonicCombinations);

fundamental = estimateFundamentalFreq(psd, 'UseParallel', opts.UseParallel);

if opts.UseParallel
    nWorkers = gcp('nocreate').NumWorkers;
else
    nWorkers = 0;
end

parfor (i = 1:nRows, nWorkers)
    % Get features for all peaks
    [peakHeight{i}, peakLoc{i}, peakWidth{i}, peakProminence{i}] = findpeaks(psd(i,:));
end

for i = 1:nRows
    % Compute how close the each peaks' frequency bin is to being an integer
    % multiple of the fundamental frequency.
    % TODO: I think this could be done with rem()
    freqBinDiffs = peakLoc{i}/fundamental(i) - fix(peakLoc{i}/fundamental(i));

    % Find the peak locations that are within nBins of an integer multiple of
    % the fundamental frequency.
    tmp = find(1 - freqBinDiffs <= nBins/fundamental(i) | freqBinDiffs <= nBins/fundamental(i));
    
    % Grab the peaks that are harmonics of the fundamental; if there are less
    % than nHarmonics, the missing harmonics are set as NaN.
    if numel(tmp) >= nHarmonics
        harmonicLoc(i,:) = peakLoc{i}(tmp(1:nHarmonics));
        harmonicWidth(i,:) = peakWidth{i}(tmp(1:nHarmonics));
        harmonicProminence(i,:) = peakProminence{i}(tmp(1:nHarmonics));
        harmonicHeight(i,:) = peakHeight{i}(tmp(1:nHarmonics));
    else
        harmonicLoc(i,1:numel(tmp)) = peakLoc{i}(tmp);
        harmonicWidth(i,1:numel(tmp)) = peakWidth{i}(tmp);
        harmonicProminence(i,1:numel(tmp)) = peakProminence{i}(tmp);
        harmonicHeight(i,1:numel(tmp)) = peakHeight{i}(tmp);
    end
    
    % Compute feature ratios for all n-choose-2 combinations of harmonics
    for n = 1:nHarmonicCombinations
        % Get the harmonic numbers we are taking a ratio of
        harmonic1 = harmonicCombinations(n, 1);
        harmonic2 = harmonicCombinations(n, 2);

        harmonicHeightRatio(i, n) = harmonicHeight(i, harmonic1) / harmonicHeight(1, harmonic2);

        harmonicWidthRatio(i, n) = harmonicWidth(i ,harmonic1) / harmonicWidth(1, harmonic2);

        harmonicProminenceRatio(i, n) = harmonicProminence(i ,harmonic1) / harmonicProminence(1, harmonic2);
    end
end

% Assemble features into our output table
features = table;

for n = 1:nHarmonics
    features.(['HarmonicHeight' num2str(n)]) = harmonicHeight(:, n);
    features.(['HarmonicLoc' num2str(n)]) = harmonicLoc(:, n);
    features.(['HarmonicWidth' num2str(n)]) = harmonicWidth(:, n);
    features.(['HarmonicProminence' num2str(n)]) = harmonicProminence(:, n);
end

for n = 1:nHarmonicCombinations
    ratioStr = strrep(num2str(harmonicCombinations(n,:)), ' ', '');
    features.(['HarmonicHeightRatio' ratioStr]) = harmonicHeightRatio(:, n);
    features.(['HarmonicWidthRatio' ratioStr]) = harmonicWidthRatio(:, n);
    features.(['HarmonicProminenceRatio' ratioStr]) = harmonicProminenceRatio(:, n);
end
end