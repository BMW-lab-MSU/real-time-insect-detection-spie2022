% one sample period of latency because of the zero-order-hold
latency = 1;

expected = extractTimeDomainFeatures(single(testData));

result = [single(meanOut), single(stdOut), single(maxDiffOut)];

error = abs((expected - result(1+latency:end,:))./expected);


assert(all(error < 5e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
