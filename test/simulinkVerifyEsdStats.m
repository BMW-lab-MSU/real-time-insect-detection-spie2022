% one sample period of latency because of the zero-order-hold rate
% transition, and another one because of how Simulink works?
latency = 1;




expected = extractPsdStats(esd);


results = [single(meanOut), single(stdOut), single(skewnessOut), single(kurtosisOut)];

error = abs((expected - results(1+latency:end,:))./expected);

% remove nan's from divide by 0
error(isnan(error)) = 0;

assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
