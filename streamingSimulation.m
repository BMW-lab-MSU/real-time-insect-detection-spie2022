% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

% if isempty(gcp('nocreate'))
%     parpool();
% end

datadir = '../../data/insect-lidar';

datafilename = [datadir filesep 'codegen-testing' filesep 'testingData.mat'];


%%
load([datadir filesep 'codegen-training' filesep 'models' filesep 'nnet'])

load(datafilename, 'testingData')

data = nestedcell2mat(testingData);
clear testingData

nRows = height(data);

labels = false(nRows, 1);

runtimes = zeros(nRows, 1);
predictionRuntime = zeros(nRows, 1);
featureExtractionRuntime = zeros(nRows, 1);


%%
profile on

% stream in the data
for i = 1:nRows
    tStart = tic;

    tFeatureExtractionStart = tic;
    features = extractFeatures(data(i,:));

    featureExtractionRuntime(i) = toc(tFeatureExtractionStart);

    tPredictStart = tic;

    labels(i) = predict(model, features);

    predictionRuntime(i) = toc(tPredictStart);

    runtimes(i) = toc(tStart);
end

profile off

disp('saving results...')

meanFeatureExtractionRuntime = mean(featureExtractionRuntime);
maxFeatureExtractionRuntime = max(featureExtractionRuntime);
stdFeatureExtractionRuntime = std(featureExtractionRuntime);
meanPredictionRuntime = mean(predictionRuntime);
maxPredictionRuntime = max(predictionRuntime);
stdPredictionRuntime = std(predictionRuntime);
meanRuntime = mean(runtimes);
maxRuntime = max(runtimes);
stdRuntime = std(runtimes);


mkdir([datadir filesep 'codegen-runtimes'])

save([datadir filesep 'codegen-runtimes' filesep ...
    'nnetStreamingSimulation.mat'],  'meanFeatureExtractionRuntime',...
    'maxFeatureExtractionRuntime', 'stdFeatureExtractionRuntime', ...
    'meanPredictionRuntime', 'maxPredictionRuntime', ...
    'stdPredictionRuntime', 'meanRuntime', 'maxRuntime', 'stdRuntime', ...
    'featureExtractionRuntime', 'predictionRuntime', 'runtimes')

profsave(profile('info'), [datadir filesep 'codegen-runtimes' filesep ...
     'nnet-streaming-simulation']);
