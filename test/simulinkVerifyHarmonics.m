
latency = 1;


expected(1,:) = extractHarmonicFeatures(single(esd(1,:)));
expected(2,:) = extractHarmonicFeatures(single(esd(2,:)));


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

assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
