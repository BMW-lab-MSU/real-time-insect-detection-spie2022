% one sample period of latency because of the zero-order-hold
latency = 1;

expected = extractTimeDomainFeatures(double(testData));


error = abs((expected - double(outputData(1+latency:end,:)))./expected);


assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
