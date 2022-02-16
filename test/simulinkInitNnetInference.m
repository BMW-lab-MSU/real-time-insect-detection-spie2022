insectLabels = find(humanLabels);

inputFeatures = [testingFeatures(insectLabels,:); testingFeatures([10,10000,20,40,100],:)];

% Using all 3444252 observations takes too long to simulate
% inputFeatures = testingFeatures;



params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

params.FFTSize = 1024;
params.rowLength = 1024;

stopTime = height(inputFeatures)*params.samplingPeriod;