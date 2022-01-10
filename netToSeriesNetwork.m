function seriesNet = netToSeriesNetwork(ogNet)

% Create the layers/architecture for the DL Toolbox network
layers = [
    featureInputLayer(30)
    fullyConnectedLayer(33)
    tanhLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer('Classes', categorical(logical([0,1])))
];

% Set pre-trained weights and biases in the new network
% NOTE: we can't set the weights/biases after the SeriesNetwork has been
% created, so we set them in the layer objects before creating the network.
layers(2).Weights = ogNet.LayerWeights{1};
layers(4).Weights = ogNet.LayerWeights{2};
layers(2).Bias = ogNet.LayerBiases{1};
layers(4).Bias = ogNet.LayerBiases{2};

% Create the SeriesNetwork
seriesNet = SeriesNetwork(layers);