function [labels, scores] = nnetInference(data)

persistent BIASES
persistent WEIGHTS
persistent trainingMean
persistent trainingStd

BASEDIR = "/vol/data/research/afrl/data/insect-lidar/codegen-training";
MODELDIR = BASEDIR + filesep + "models";

if isempty(WEIGHTS)
    load(MODELDIR + filesep + "nnet")
    WEIGHTS = model.LayerWeights;
end
if isempty(BIASES)
    BIASES = model.LayerBiases;
end
if isempty(trainingMean)
    load(BASEDIR + filesep + "trainingNormalizationFactors")
end


% transpose so we are working with column vectors
x0 = ((data - trainingMean)./trainingStd)';

s1 = WEIGHTS{1} * x0 + BIASES{1};

x1 = 1./(1 + exp(-s1));

s2 = WEIGHTS{2} * x1 + BIASES{2};

% softmax
x2 = softmax(s2);

scores = x2';

labels = find(x2 > 0.5) - 1;
