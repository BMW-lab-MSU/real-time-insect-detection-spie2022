function fundamental = estimateFundamentalFreq(psd)
% estimateFundamentalFreq estimate the fundamental frequency in a PSD using the
% harmonic product spectrum
%
%   fundamental = estimateFundamentalFreq(psd) estimates the fundamental
%   frequency in the one-sided power spectral density magnitude, psd. 
%
%   See also harmonicProductSpectrum.

% SPDX-License-Identifier: BSD-3-Clause

fundamental = zeros(height(psd), 1, 'like', psd);

hps = harmonicProductSpectrum(psd, 3);

for i = 1:height(psd)
    [~, fundamental(i)] = findpeaks(hps(i,:), 'NPeaks', 1, ...
        'SortStr', 'descend');
end

end