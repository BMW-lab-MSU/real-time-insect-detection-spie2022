
latency = 1;


expected = extractHarmonicFeatures(esd);


featuresOut = [
    single(harmonicHeightsOut(1+latency:end, :)),...
    single(harmonicWidthsOut(1+latency:end, :)),...
    single(harmonicProminencesOut(1+latency:end, :)),...
    single(harmonicHeightRatiosOut(1+latency:end, :)),...
    single(harmonicWidthRatiosOut(1+latency:end, :)),...
    single(harmonicProminenceRatiosOut(1+latency:end, :)),...
    single(harmonicLocationsOut(1+latency:end, :))
];

error = abs((expected - featuresOut)./expected);

% don't divide by 0 when the expected feature is 0
z = expected == 0;
error(z) = abs(expected(z) - featuresOut(z));

assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
