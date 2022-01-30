% Testbench file used in converting nnetInference to fixed point. This lets the
% fixed-point designer app simulate and determine the data ranges for each
% variable so it can suggest appropriate fixed point datatypes.

DATADIR = "../../data/insect-lidar/testing";
load(DATADIR + filesep + "testingData", "testingData")

data = nestedcell2mat(testingData);
data = data(1:1000,:);
features = zeros(1000,30);

for i = 1:height(data)
    features(i,:) = extractFeatures(data(i,:));
end
