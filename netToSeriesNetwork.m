function seriesNet = netToSeriesNetwork(ogNet, trainingMean, trainingStd)

% Create the layers/architecture for the DL Toolbox network
layers = [
    featureInputLayer(30, 'Normalization', 'zscore', 'Mean', trainingMean, ...
        'StandardDeviation', trainingStd)
    fullyConnectedLayer(13)
    tanhLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer('Classes', categorical(logical([0,1])))
];

% Set pre-trained weights and biases in the new network
% NOTE: we can't set the weights/biases after the SeriesNetwork has been
% created, so we set them in the layer objects before creating the network.
% NOTE: I could set these in the layer constructor functions instead
layers(2).Weights = ogNet.LayerWeights{1};
layers(4).Weights = ogNet.LayerWeights{2};
layers(2).Bias = ogNet.LayerBiases{1};
layers(4).Bias = ogNet.LayerBiases{2};

% Create the SeriesNetwork
seriesNet = SeriesNetwork(layers);