
data = rand(1, 1024);
psd = abs(fft(data, [], 2)).^2;
psd = psd(:,1:end/2);
psd = psd./psd(:,1);

newFeatures = extractHarmonicFeatures(psd);