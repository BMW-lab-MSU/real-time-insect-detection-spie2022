% testData = fi([1:1024; 2*(1:1024); 3*(1:1024); 4*(1:1024)]);
% testData = single([1:1024; 2*(1:1024); 3*(1:1024); 4*(1:1024)]);
% testData = rand(2,1024, 'single');
% testData = fi(rand(2,1024), 1, 20, 16);


% XXX: I'm not sure the following test case doesn't work. For some reason,
%      it seems like the simulation is giving NaNs for the ESD, but my 
%      MATLAB calculations don't...
t = 1:1024;
testData = single([sin(2*pi*100*t/1024) + sin(2*pi*200*t/1024) + sin(2*pi*300*t/1024); ...
    sin(2*pi*50*t/1024) + sin(2*pi*150*t/1024) + sin(2*pi*250*t/1024)]) + 5;



params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

params.FFTSize = 1024;
params.rowLength = 1024;

stopTime = 4*params.samplingPeriod;