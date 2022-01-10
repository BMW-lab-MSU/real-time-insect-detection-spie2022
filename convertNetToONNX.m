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


% Load pre-trained nerual network and training data
baseDir = "../../data/insect-lidar/MLSP-2021/training";
load(baseDir + filesep + "models" + filesep + "nnet")
load(baseDir + filesep + "trainingData", 'trainingFeatures')
trainingFeatures = nestedcell2mat(trainingFeatures);

% Compute the mean and standard deviation of the training data so we can set
% those in the new input layer's normalization routine
% NOTE: the uniform output format requries that the data types for each entry
%       are the same. Unfortunately, some of the variables in the table ended
%       up as doubles instead of singles... Rather than fixing that at the
%       source and making a new trainingData.mat file, I'm making everything
%       a single here instead. Fixing it at the source would be preferable...
trainingFeatures = varfun(@single, trainingFeatures);
trainingMean = varfun(@(f) mean(f, 'omitnan'), trainingFeatures, 'OutputFormat', 'uniform');
trainingStd = varfun(@(f) std(f,'omitnan'), trainingFeatures, 'OutputFormat', 'uniform');

seriesNet = netToSeriesNetwork(model, trainingMean, trainingStd);

% Export the model as an ONNX file so we can generate HDL with external tools
exportONNXNetwork(seriesNet, baseDir + filesep + "models" + filesep + "nnet.onnx");