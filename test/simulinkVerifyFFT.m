% one sample period of latency because of the zero-order-hold rate
% transition, and another one because of how Simulink works?
latency = 2;

expected = fft(double(testData), [], 2);

error = abs((expected - double(outputData(1+latency:end,:)))./expected);

assert(all(error < 1e-2, 'all'), 'verification failed')
disp('verification passed')
