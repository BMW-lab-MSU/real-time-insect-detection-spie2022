% testData = fi([1:1024; 2*(1:1024); 3*(1:1024); 4*(1:1024)]);
testData = single([1:1024; 2*(1:1024); 3*(1:1024); 4*(1:1024)]);


params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

stopTime = 5*params.samplingPeriod;