% Gather layer weights/biases and input normalization factors into one mat file
% to make using the HDL Coder easier.
% https://www.mathworks.com/help/hdlcoder/ug/load-constants-from-a-mat-file.html

load('/vol/data/research/afrl/data/insect-lidar/training/models/nnet')
load('/vol/data/research/afrl/data/insect-lidar/training/trainingNormalizationFactors')

% transpose so we can keep the input data as a row vector
weightsLayer1 = model.LayerWeights{1}';
weightsLayer2 = model.LayerWeights{2}';
biasesLayer1 = model.LayerBiases{1}';
biasesLayer2 = model.LayerBiases{2}';

% use the reciprocal of the std deviation so we can do multiplication instead
% of division
trainingStdInv = 1./trainingStd;

save('nnetCodegenConstants', 'weightsLayer1', 'weightsLayer2', ...
    'biasesLayer1', 'biasesLayer2', 'trainingMean', 'trainingStdInv')

