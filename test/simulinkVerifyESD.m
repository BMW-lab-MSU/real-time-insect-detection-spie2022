% one sample period of latency because of the zero-order-hold rate
% transition, and another one because of how Simulink works?
latency = 2;

spectrum = fft(double(testData), [], 2);
esd = real(spectrum).^2 + imag(spectrum).^2;
esd = esd(:,1:end/2);
expected = esd ./ esd(:,1);


error = abs((expected - double(outputData(1+latency:end,:)))./expected);

assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
