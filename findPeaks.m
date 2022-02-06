function [heights, locations, widths, prominences] = findPeaks(x)
% findPeaks Find local maxima in a 1D signal
%
%   A peak is defined as any sample that is larger than it's neighbors.
%
%   [heights, locations, widths, prominences] = findPeaks(x) finds all peaks in
%   the signal x. It returns the height, location, width, and prominence of each
%   peak. The peak widths are measured at half-prominence height.
%
%   For plateaus, findPeaks returns the first index of the plateau.

% Much of the code contained here was ported from scipy's find_peaks
% implementation. scipy is licensed under the BSD 3-clause license.
% Copyright (c) 2001-2002 Enthought, Inc. 2003-2022, SciPy Developers
% Copyright (c) 2022 Trevor Vannoy
% SPDX-License-Identifier: BSD-3-Clause

locations = localMaxima1d(x);

heights = zeros(size(locations), 'like', x);
for i = 1:numel(locations)
    if locations(i) ~= 0
        heights(i) = x(locations(i));
    end
end

[prominences, leftBases, rightBases] = peakProminence(x, locations);

widths = peakWidths(x, locations, prominences, leftBases, rightBases);


end

function [locations] = localMaxima1d(x)
% localMaxima1d Find local maxima in a 1D array
%
% Inputs:
%   - x: the signal in which to find maxima
%
% Outputs:
%   - locations: the indices of each maxima/peak

% preallocate; there can't be more maxima than half the size of x
locations = zeros(1, numel(x)/2, 'like', x);
nPeaksIdx = 1;


% the first sample can't be a maxima, so we start at 2
iMin = 2;
% last sample can't be a maxima either
iMax = numel(x) - 1;

for i =  iMin:iMax
    % if the previous sample is smaller and the next sample is at least
    % as small, we've found a peak. 
    if x(i - 1) < x(i)

        % if the next sample is equal to the current one, we've hit a plateau;
        % we return the beginning of the plateau as the peak location, which
        % is consistent with MATLAB's findpeaks behavior.
        if x(i + 1) <= x(i)
            locations(nPeaksIdx) = i;
            nPeaksIdx(:) = nPeaksIdx + 1;
        end
    end

end
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
leftBases = zeros(size(locations), 'like', x);
rightBases = zeros(size(locations), 'like', x);

for peakNum = 1:numel(locations)
    % locations == 0 means there wasn't a peak, so skip those
    if locations(peakNum) ~= 0
        location = locations(peakNum);
        iMin = 1;
        iMax = numel(x);

        % Find the left base in interval [iMin, location]
        leftBases(peakNum) = location;
        i = location;
        leftMin = x(location);

        leftBorder = iMin;
        for i = iMin:location-1
            if x(i) >= x(location)
                leftBorder = i;
            end
        end
        for i = location:-1:leftBorder
            if x(i) < leftMin
                leftMin = x(i);
                leftBases(peakNum) = i;
            end
        end

        % Find the right base in interval [location, iMax]
        rightBases(peakNum) = location;
        i = location;
        rightMin = x(location);

        rightBorder = iMax;
        for i = iMax:-1:location+1
            if x(i) >= x(location)
                rightBorder = i;
            end
        end
        for i = rightBorder:-1:location
            if x(i) < rightMin
                rightMin = x(i);
                rightBases(peakNum) = i;
            end
        end

        prominences(peakNum) = x(location) - max(leftMin, rightMin);
    end
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
    % locations == 0 means there wasn't a peak, so skip those
    if locations(peakNum) ~= 0
        iMin = leftBases(peakNum);
        iMax = rightBases(peakNum);
        location = locations(peakNum);

        height = x(location) - prominences(peakNum) * relHeight;

        % Find intersection point on left side
        leftIp = cast(iMin, 'like', x);
        done = false;
        for i = location:-1:iMin
            if ~done
                if x(i) <= height
                    done = true;
                    leftIp = cast(i, 'like', x);
                end
            end
        end
        
        if x(leftIp) < height
            % Interpolate if true intersection height is between samples
            leftIp = leftIp + (height - x(leftIp)) / (x(leftIp + 1) - x(leftIp));
        end

        % Find intersection point on right side
        rightIp = cast(iMax, 'like', x);
        done = false;
        for i = location:iMax
            if ~done
                if x(i) <= height
                    done = true;
                    rightIp = cast(i, 'like', x);
                end
            end
        end

        if x(rightIp) < height
            % Interpolate if true intersection height is between samples
            rightIp = rightIp - (height - x(rightIp)) / (x(rightIp - 1) - x(rightIp));
        end

        widths(peakNum) = rightIp - leftIp;
    end
end
end
