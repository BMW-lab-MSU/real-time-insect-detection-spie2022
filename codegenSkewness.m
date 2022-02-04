function s = codegenSkewness(x)
% codegenSkewness compute the skewness of x
%
% MATLAB's skewness implementation doesn't support fixed-point,
% possibly due to 'dimension' argument. By hardcoding the dimension,
% this version is fixed-point compatible.


xCentered = x - mean(x,2);

secondMoment = mean(xCentered.^2, 2);

thirdMoment = mean(xCentered.^3, 2);

denominator = sqrt(secondMoment).^3;

s = thirdMoment ./ denominator;
