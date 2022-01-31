% Testbench file used in converting nnetInference to fixed point. This lets the
% fixed-point designer app simulate and determine the data ranges for each
% variable so it can suggest appropriate fixed point datatypes.

DATADIR = "../../data/insect-lidar/testing";
load(DATADIR + filesep + "testingData", "testingData")

nDataPoints = 50e3;

data = nestedcell2mat(testingData);

dataIdx = randperm(size(data,1), nDataPoints);

data = data(dataIdx,:);
features = zeros(nDataPoints,30);

for i = 1:height(data)
    features(i,:) = extractFeatures(data(i,:));
end
