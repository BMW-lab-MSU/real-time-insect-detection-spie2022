% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

datadir = '../../data/insect-lidar';

%% Load data
load([datadir filesep 'scans.mat']);
load([datadir filesep 'codegen-testing' filesep 'testingData.mat']);

imageLabels = vertcat(scans(test(holdoutPartition)).ImageLabels);
clear scans

features = nestedcell2mat(testingFeatures);
labels = nestedcell2mat(testingLabels);


%% Test neural net
disp('Testing neural net....')
disp('---------------')
disp('')
load([datadir filesep 'codegen-training' filesep 'models' filesep 'nnet.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
nnet.Row.PredLabels = predict(model, features);

nnet.Row.Confusion = confusionmat(labels, nnet.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(nnet.Row.Confusion);
nnet.Row.Accuracy = a;
nnet.Row.Precision = p;
nnet.Row.Recall = r;
nnet.Row.F2 = f2;
nnet.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
nnet.Image.Confusion = imageConfusion(nnet.Row.PredLabels, testingLabels, holdoutPartition);

[a, p, r, f2, mcc] = analyzeConfusion(nnet.Image.Confusion);
nnet.Image.Accuracy = a;
nnet.Image.Precision = p;
nnet.Image.Recall = r;
nnet.Image.F2 = f2;
nnet.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(nnet.Row.Confusion)
disp(nnet.Row)
disp('Image results')
disp(nnet.Image.Confusion)
disp(nnet.Image)

%% Save results
save([datadir filesep 'codegen-testing' filesep 'results'], 'nnet');
