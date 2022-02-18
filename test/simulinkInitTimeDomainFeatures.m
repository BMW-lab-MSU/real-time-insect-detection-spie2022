% testData = fi([1:1024; 2*(1:1024)]);
% testData = single([1:1024; 2*(1:1024)]);
% testData = rand(2,1024, 'single');
testData = fi(rand(2,1024, 'single'), 0, 27, 26);



params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

params.FFTSize = 1024;
params.rowLength = 1024;

stopTime = height(testData)*params.samplingPeriod;