insectLabels = find(humanLabels);

observationIndices = [(1:1e3)'; insectLabels];
inputFeatures = extractFeatures(testingData(observationIndices,:));

% Using all 3444252 observations takes too long to simulate
% inputFeatures = testingFeatures;



params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

params.FFTSize = 1024;
params.rowLength = 1024;

stopTime = height(inputFeatures)*params.samplingPeriod;