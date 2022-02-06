% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

if isempty(gcp('nocreate'))
    parpool();
end

% Set random number generator properties for reproducibility
rng(0, 'twister');

datadir = '../../data/insect-lidar/';
datafile = 'scans.mat';

%% Load data
load([datadir filesep datafile])


%% Extract features
scanFeatures = cell(numel(scans), 1);

parfor i = 1:numel(scans)
    scanFeatures{i} = cellfun(@(X) extractFeatures(X), ...
        scans(i).Data, 'UniformOutput', false);
end

%%
labels = {scans.Labels}';
scanLabels = vertcat(scans.ScanLabel);

%% Partition into training and test sets
TEST_PCT = 0.2;

holdoutPartition = cvpartition(scanLabels, 'Holdout', TEST_PCT, 'Stratify', true);


trainingData = {scans(training(holdoutPartition)).Data}';
testingData = {scans(test(holdoutPartition)).Data}';
trainingFeatures = scanFeatures(training(holdoutPartition));
testingFeatures = scanFeatures(test(holdoutPartition));
trainingLabels = labels(training(holdoutPartition));
testingLabels = labels(test(holdoutPartition));

%% Partition the data for k-fold cross validation
N_FOLDS = 5;

crossvalPartition = cvpartition(scanLabels(training(holdoutPartition)), ...
    'KFold', N_FOLDS, 'Stratify', true);


%% Save training and testing data
mkdir(datadir, 'codegen-testing');
save([datadir filesep 'codegen-testing' filesep 'testingData.mat'], ...
    'testingData', 'testingFeatures', 'testingLabels', ...
    'holdoutPartition', 'scanLabels', '-v7.3');

mkdir(datadir, 'codegen-training');
save([datadir filesep 'codegen-training' filesep 'trainingData.mat'], ...
    'trainingData', 'trainingFeatures', 'trainingLabels', ...
    'crossvalPartition', 'holdoutPartition', 'scanLabels', '-v7.3');
