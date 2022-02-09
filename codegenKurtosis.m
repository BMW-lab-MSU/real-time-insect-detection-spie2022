function k = codegenKurtosis(x)
% codegenKurtosis compute the kurtosis of x
%
% MATLAB's kurtosis implementation doesn't support fixed-point,
% possibly due to 'dimension' argument. By hardcoding the dimension,
% this version is fixed-point compatible.

%#codegen

xCentered = zeros(size(x), 'like', x);
xCentered2 = zeros(size(x), 'like', x);
xCentered3 = zeros(size(x), 'like', x);
xCentered4 = zeros(size(x), 'like', x);
secondMoment = zeros(size(x,1), 1, 'like', x);
fourthMoment = zeros(size(x,1), 1, 'like', x);
denominator = zeros(size(x,1), 1, 'like', x);
k = zeros(size(x,1), 1, 'like', x);

xCentered(:) = x - mean(x,2);
xCentered2(:) = xCentered .* xCentered;
xCentered3(:) = xCentered2 .* xCentered;
xCentered4(:) = xCentered3 .* xCentered;


secondMoment(:) = mean(xCentered2, 2);

fourthMoment(:) = mean(xCentered4, 2);

denominator(:) = secondMoment .* secondMoment;

k(:) = fourthMoment ./ denominator;
