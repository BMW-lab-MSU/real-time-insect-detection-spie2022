params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

params.FFTSize = 1024;
params.rowLength = 1024;

observationIndices = [insectLabels];

% inputData = fi([data(observationIndices,:)], 0, 32, 31);
inputData = data(observationIndices,:);

stopTime = (height(inputData) + 1) * params.samplingPeriod;