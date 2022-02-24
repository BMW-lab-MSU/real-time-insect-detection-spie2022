% one sample period of latency because of the zero-order-hold rate
% transition, and another one because of how Simulink works?
latency = 2;

spectrum = fft(single(inputData), [], 2);
esd = real(spectrum).^2 + imag(spectrum).^2;
esd = esd(:,1:end/2);
esd = esd ./ esd(:,1);

expectedHarmonicFeatures = extractHarmonicFeatures(esd);


expectedEsdStats = extractPsdStats(esd);


expectedTimeDomainFeatures = extractTimeDomainFeatures(single(inputData));

timeDomainFeaturesOut = [single(meanOut), single(stdOut), single(maxDiffOut)];

esdStatsOut = [single(meanEsdOut), single(stdEsdOut), single(skewnessEsdOut), single(kurtosisEsdOut)];

harmonicFeaturesOut = [
    single(harmonicHeightsOut(1+latency:end, :)),...
    single(harmonicWidthsOut(1+latency:end, :)),...
    single(harmonicProminencesOut(1+latency:end, :)),...
    single(harmonicHeightRatiosOut(1+latency:end, :)),...
    single(harmonicWidthRatiosOut(1+latency:end, :)),...
    single(harmonicProminenceRatiosOut(1+latency:end, :)),...
    single(harmonicLocationsOut(1+latency:end, :))
];

expectedFeatures = [expectedTimeDomainFeatures, expectedEsdStats, expectedHarmonicFeatures];
featuresOut = [timeDomainFeaturesOut(1+latency:end,:), esdStatsOut(1+latency:end,:), harmonicFeaturesOut];

error = abs((expectedFeatures - featuresOut)./expectedFeatures);

% Don't divide by zero when the expected feature is 0
z = expectedFeatures == 0;
error(z) = abs(expectedFeatures(z) - featuresOut(z));

assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
