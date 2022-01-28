% Compute the mean and standard deviation of the training data so they can be
% used for input data normalization when the neural network gets new samples for
% inference.

% SPDX-License-Identifier: BSD-3-Clause

DATADIR = "../../data/insect-lidar/training";
load(DATADIR + filesep + "trainingData", "trainingFeatures")

trainingFeatures = nestedcell2mat(trainingFeatures);

trainingMean = varfun(@(feature) mean(feature, 'omitnan'), trainingFeatures,...
    'OutputFormat', 'uniform');
trainingStd = varfun(@(feature) std(feature, 'omitnan'), trainingFeatures,...
    'OutputFormat', 'uniform');

save(DATADIR + filesep + "trainingNormalizationFactors", 'trainingMean', 'trainingStd', '-v7.3')