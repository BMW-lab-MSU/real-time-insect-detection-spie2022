%% Convert the pre-trained neural network into an ONNX file
% The CompactClassificationNeuralNetwork from the Statistics and Machine
% Learning Toolbox was used to create and train the neural network
% (see trainNet.m at 
% https://github.com/BMW-lab-MSU/insect-lidar-supervised-classification).
% Unfortunatley, the HDL Coder doesn't support generating code for that
% network, and MATLAB's exportToONNXModel function doesn't support that
% network either (it only supports some models from the Deep Learning
% Toolbox). To work around this, we create a SeriesNetwork from the Deep
% Learning Toolbox that is identical to our pre-trained network from the
% Stats and ML Toolbox; this allows us to export the network to an ONNX
% file.

% SPDX-License-Identifier: BSD-3-Clause


% Load pre-trained nerual network
modelDir = "../../data/insect-lidar/MLSP-2021/training/models";
load(modelDir + filesep + "nnet")

seriesNet = netToSeriesNetwork(model);

% Export the model as an ONNX file so we can generate HDL with external tools
exportONNXNetwork(seriesNet, modelDir + filesep + "nnet.onnx");