function [label, scores] = nnetInference(data)

% INFO: loading compile-time constants from a MAT file:
% https://www.mathworks.com/help/hdlcoder/ug/load-constants-from-a-mat-file.html

persistent codegenConstants

if isempty(codegenConstants)
    codegenConstants = coder.load('nnetCodegenConstants');
end

weightsLayer1 = codegenConstants.weightsLayer1;
weightsLayer2 = codegenConstants.weightsLayer2;
biasesLayer1 = codegenConstants.biasesLayer1;
biasesLayer2 = codegenConstants.biasesLayer2;
trainingMean = codegenConstants.trainingMean;
trainingStdInv = codegenConstants.trainingStdInv;

% transpose so we are working with column vectors
% TODO: this transpose really isn't necessary, and I should probably
%       get rid of it before converting to HDL
x0 = ((data - trainingMean) .* trainingStdInv)';

s1 = weightsLayer1 * x0 + biasesLayer1;

% The fixed-point designer toolbox can only create 1D lookup tables so we have
% to call tanh on scalars instead of vectors in order to be able to
% automatically create a lookup table for it
x1 = zeros(size(s1));
for i = 1:numel(x1)
    x1(i) = tanh(s1(i));
end

s2 = weightsLayer2 * x1 + biasesLayer2;

[x21, x22] = softmax(s2(1), s2(2));

scores = [x21, x22];

% The classes are [non-insect, insect], in that order, so scores(1) >= scores(2)
% means that the predicted class is "non-insect" (false).
if scores(1) >= scores(2)
    label = false;
else
    label = true;
end

end

% The fixed-point designer toolbox can only create 1D lookup tables so we have
% to call softmax on scalars instead of vectors in order to be able to
% automatically create a lookup table for it.
function [out1, out2] = softmax(in1, in2)
expIn1 = exp(in1);
expIn2 = exp(in2);

% TODO: it'd be nice to get rid of this division if possible
out1 = (expIn1) / (expIn1 + expIn2);
out2 = (expIn2) / (expIn1 + expIn2);
end

