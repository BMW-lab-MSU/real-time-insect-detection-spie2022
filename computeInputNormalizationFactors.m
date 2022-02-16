% Compute the mean and standard deviation of the training data so they can be
% used for input data normalization when the neural network gets new samples for
% inference.

% SPDX-License-Identifier: BSD-3-Clause

DATADIR = "../../data/insect-lidar/codegen-training";
load(DATADIR + filesep + "trainingData", "trainingFeatures")

trainingFeatures = nestedcell2mat(trainingFeatures);

trainingMean = mean(trainingFeatures, 1);
trainingStd = std(trainingFeatures, 0, 1);

save(DATADIR + filesep + "trainingNormalizationFactors", 'trainingMean', 'trainingStd', '-v7.3')