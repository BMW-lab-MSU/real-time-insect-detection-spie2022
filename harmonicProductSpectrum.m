function hps = harmonicProductSpectrum(spectrum, nSpectra)
% harmonicProductSpectrum compute the harmonic product spectrum of a one-sided
% spectrum or PSD
%
%   hps = harmonicProductSpectrum(spectrum, nSpectra) computes the haromnic
%   product spectrum. spectrum is a one-sided magnitude spectrum or one-sided
%   power spectral density. nSpectra determines the the number of spectral
%   copies to use when computing the harmonic product spectrum.

% SPDX-License-Identifier: BSD-3-Clause

rows = size(spectrum,1);
cols = floor(size(spectrum,2) / nSpectra);


hps = spectrum(:,1:cols);
hps(:) = hps .* spectrum(:,1:2:2*cols);
hps(:) = hps .* spectrum(:,1:3:3*cols);

end