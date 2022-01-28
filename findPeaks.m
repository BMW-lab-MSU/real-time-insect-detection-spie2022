function [heights, locations, widths, prominences] = findPeaks(x)
% findPeaks Find local maxima in a 1D signal
%
%   A peak is defined as any sample that is larger than it's neighbors.
%
%   [heights, locations, widths, prominences] = findPeaks(x) finds all peaks in
%   the signal x. It returns the height, location, width, and prominence of each
%   peak. The peak widths are measured at half-prominence height.
%
%   For plateaus, findPeaks returns the middle index of the plateau, rounding up
%   for plateaus with an even number of samples.

% All the code contained here was ported from scipy's find_peaks
% implementation. scipy is licensed under the BSD 3-clause license.
% Copyright (c) 2001-2002 Enthought, Inc. 2003-2022, SciPy Developers
% Copyright (c) 2022 Trevor Vannoy
% SPDX-License-Identifier: BSD-3-Clause

[locations, leftEdges, rightEdges] = localMaxima1d(x);

heights = x(locations);

[prominences, leftBases, rightBases] = peakProminence(x, locations);

widths = peakWidths(x, locations, prominences, leftBases, rightBases);


end

function [midpoints, leftEdges, rightEdges] = localMaxima1d(x)
% localMaxima1d Find local maxima in a 1D array
%
% Inputs:
%   - x: the signal in which to find maxima
%
% Outputs:
%   - midpoints: the midpoint indices of each maxima/peak
%   - leftEdges: Indices for the left edges of each maxima
%   - rightEdges: indices for the right edges of each maxima

% preallocate; there can't be more maxima than half the size of x
midpoints = zeros(1, numel(x), 'uint32');
leftEdges = zeros(1, numel(x), 'uint32');
rightEdges = zeros(1, numel(x), 'uint32');
nPeaksIdx = 1;

% the first sample can't be a maxima, so we start at 2
i = 2;

% last sample can't be a maxima either
iMax = numel(x);

while i < iMax
    % test if previous sample is smaller
    if x(i - 1) < x(i)
        iAhead = i + 1;

        % find the next sample that is unequal to x[i]
        while iAhead < iMax && x(iAhead) == x(i)
            iAhead = iAhead + 1;
        end

        % maxima is found if next unequal sample is smaller than x[i]
        if x(iAhead) < x(i)
            leftEdges(nPeaksIdx) = i;
            rightEdges(nPeaksIdx) = iAhead - 1;
            midpoints(nPeaksIdx) = (leftEdges(nPeaksIdx) + rightEdges(nPeaksIdx)) / 2;
            nPeaksIdx = nPeaksIdx + 1;

            % skip samples that can't be maxima
            i = iAhead;
        end
    end

    i = i + 1;
end

% resize based upon how many peaks were found
midpoints = midpoints(1:nPeaksIdx-1);
leftEdges = leftEdges(1:nPeaksIdx-1);
rightEdges = rightEdges(1:nPeaksIdx-1);
end

function [prominences, leftBases, rightBases] = peakProminence(x, locations)
% peakProminence Calculate the prominence of each peak in a signal.
%
% Inputs:
%   - x: the signal
%   - locations: the locations of each peak in x
%
% Outputs:
%   - prominences: the prominence for each peak
%   - leftBases: the left base of each peak
%   - rightBases: the right base of each peak

% preallocate
prominences = zeros(size(locations), 'like', x);
leftBases = zeros(size(locations), 'uint32');
rightBases = zeros(size(locations), 'uint32');

for peakNum = 1:numel(locations)
    location = locations(peakNum);
    iMin = 1;
    iMax = numel(x);

    % Find the left base in interval [iMin, location]
    leftBases(peakNum) = location;
    i = location;
    leftMin = x(location);

    while iMin <= i && x(i) <= x(location)
        if x(i) < leftMin
            leftMin = x(i);
            leftBases(peakNum) = i;
        end
        i = i - 1;
    end

    % Find the right base in interval [location, iMax]
    rightBases(peakNum) = location;
    i = location;
    rightMin = x(location);

    while i<= iMax && x(i) <= x(location)
        if x(i) < rightMin
            rightMin = x(i);
            rightBases(peakNum) = i;
        end
        i = i + 1;
    end

    prominences(peakNum) = x(location) - max(leftMin, rightMin);
end
end

function widths = peakWidths(x, locations, prominences, leftBases, rightBases)
% peakWidths Calculate the half-prominence width of each peak
%
% Inputs:
%   - x: the signal
%   - locations: the locations of each peak in x
%   - prominences: the prominence for each peak
%   - leftBases: the left base of each peak
%   - rightBases: the right base of each peak
%
% Outputs:
%   - widths: the width for each peak

% widths are measured at half-prominence height
relHeight = 0.5;

widths = zeros(size(locations), 'like', x);

for peakNum = 1:numel(locations)
    iMin = leftBases(peakNum);
    iMax = rightBases(peakNum);
    location = locations(peakNum);

    height = x(location) - prominences(peakNum) * relHeight;

    % Find intersection point on left side
    i = location;
    while iMin < i && height < x(i)
        i = i - 1;
    end
    leftIp = double(i);
    if x(i) < height
        % Interpolate if true intersection height is between samples
        leftIp = leftIp + (height - x(i)) / (x(i + 1) - x(i));
    end

    % Find intersection point on right side
    i = location;
    while i < iMax && height < x(i)
        i = i + 1;
    end
    rightIp = double(i);
    if x(i) < height
        % Interpolate if true intersection height is between samples
        rightIp = rightIp - (height - x(i)) / (x(i - 1) - x(i));
    end

    widths(peakNum) = rightIp - leftIp;
end
end
