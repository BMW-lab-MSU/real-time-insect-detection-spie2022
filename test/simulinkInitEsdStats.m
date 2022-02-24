% testData = fi([1:1024; 2*(1:1024)]);
% testData = single([1:1024; 2*(1:1024); 3*(1:1024); 4*(1:1024)]);
% testData = rand(2,1024, 'single');

observationIndices = [insectLabels];

testData = data(observationIndices, :);

spectrum = fft(testData, [], 2);
esd = real(spectrum).^2 + imag(spectrum).^2;
esd = esd(:,1:end/2);
esd = esd ./ esd(:,1);


params.systemClockPeriod = 25e-9;
params.samplingPeriod = 781.25e-6;

params.FFTSize = 1024;
params.rowLength = 1024;

stopTime = height(esd)*params.samplingPeriod;