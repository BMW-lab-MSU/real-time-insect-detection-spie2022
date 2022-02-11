% one sample period of latency because of the zero-order-hold rate
% transition, and another one because of how Simulink works?
latency = 2;

spectrum = fft(double(testData), [], 2);
esd = real(spectrum).^2 + imag(spectrum).^2;
esd = esd(:,1:end/2);
esd = esd ./ esd(:,1);

expected = zeros(size(esd,1), 6);
for i = 1:size(esd,1)
    expected(i,:) = extractPsdStats(esd(i,:));
end


error = abs((expected(:,[1,2,5,6]) - double(outputData(1+latency:end,:)))./expected(:,[1,2,5,6]));

% remove nan's from divide by 0
error(isnan(error)) = 0;

assert(all(error < 1e-2, 'all'), 'verification failed')
disp(['verification passed: max error = ' num2str(max(error(:)))])
