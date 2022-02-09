function fundamental = estimateFundamentalFreq(psd)
% estimateFundamentalFreq estimate the fundamental frequency in a PSD using the
% harmonic product spectrum
%
%   fundamental = estimateFundamentalFreq(psd) estimates the fundamental
%   frequency in the one-sided power spectral density magnitude, psd. 
%
%   See also harmonicProductSpectrum.

% SPDX-License-Identifier: BSD-3-Clause

%#codegen

hps = harmonicProductSpectrum(psd, 3);
[heights, locs] = findPeaks(hps);
[~,maxPeakIdx] = max(heights);
fundamental = locs(maxPeakIdx);

end