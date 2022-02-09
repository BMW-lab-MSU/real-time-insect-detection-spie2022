function s = codegenSkewness(x)
% codegenSkewness compute the skewness of x
%
% MATLAB's skewness implementation doesn't support fixed-point,
% possibly due to 'dimension' argument. By hardcoding the dimension,
% this version is fixed-point compatible.

%#codegen

xCentered = zeros(size(x), 'like', x);
xCentered2 = zeros(size(x), 'like', x);
xCentered3 = zeros(size(x), 'like', x);
secondMoment = zeros(size(x,1), 1, 'like', x);
thirdMoment = zeros(size(x,1), 1, 'like', x);
denominator = zeros(size(x,1), 1, 'like', x);
s = zeros(size(x,1), 1, 'like', x);


xCentered = x - mean(x,2);

xCentered2(:) = xCentered .* xCentered;
xCentered3(:) = xCentered2 .* xCentered;

secondMoment(:) = mean(xCentered2, 2);

thirdMoment(:) = mean(xCentered3, 2);

denominator(:) = sqrt(secondMoment.^3);

s(:) = thirdMoment ./ denominator;
