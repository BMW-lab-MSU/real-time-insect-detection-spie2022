function k = codegenKurtosis(x)
% codegenKurtosis compute the kurtosis of x
%
% MATLAB's kurtosis implementation doesn't support fixed-point,
% possibly due to 'dimension' argument. By hardcoding the dimension,
% this version is fixed-point compatible.

xCentered = x - mean(x,2);

secondMoment = mean(xCentered.^2, 2);

fourthMoment = mean(xCentered.^4, 2);

denominator = secondMoment.^2;

k = fourthMoment ./ denominator;
