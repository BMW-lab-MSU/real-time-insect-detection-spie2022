datadir = "../../data/insect-lidar";

load(datadir + filesep + "codegen-testing" + filesep + "expectedLabels")
load(datadir + filesep + "codegen-testing" + filesep + "predictedLabels")
load(datadir + filesep + "codegen-testing" + filesep +  "testingData", "testingLabels", "testingFeatures");
load(datadir + filesep + "codegen-training" + filesep +  "models" + filesep + "nnet");

testingFeatures = nestedcell2mat(testingFeatures);

trueLabels = nestedcell2mat(testingLabels);

%% compute recalls
trueInsectLabels = find(trueLabels);

insectObservations = testingFeatures(trueInsectLabels, :);

matlabInsectPredictions = expectedLabels(trueInsectLabels);

numMatlabTP = numel(find(matlabInsectPredictions))
matlabRecall = numMatlabTP / numel(matlabInsectPredictions)

numSimulinkTP = numel(find(predictedLabels))
simulinkRecall = numSimulinkTP / numel(predictedLabels)

%% find the scores of the insects that Simulink labeled different than MATLAB
mismatches = find(matlabInsectPredictions ~= predictedLabels);

[l, scores] = predict(model, insectObservations(mismatches,:))


