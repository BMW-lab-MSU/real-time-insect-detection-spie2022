% Testbench file used in converting nnetInference to fixed point. This lets the
% fixed-point designer app simulate and determine the data ranges for each
% variable so it can suggest appropriate fixed point datatypes.

DATADIR = "../../data/insect-lidar/testing";
load(DATADIR + filesep + "testingData", "testingFeatures")

featuresTable = nestedcell2mat(testingFeatures);
features = table2array(featuresTable);
features(isnan(features)) = 0;

labels = false(height(features), 1);
scores = zeros(height(features), 2, 'single');

for i = 1:height(features)
    [labels(i), scores(i,:)] = nnetInferenceHDL(features(i,:));
end