baseDir = "../../../data/insect-lidar";
testingDataDir = baseDir + filesep + "codegen-testing";

load(testingDataDir + filesep + "testingData", "testingFeatures", "testingLabels")

testingFeatures = nestedcell2mat(testingFeatures);
humanLabels = nestedcell2mat(testingLabels);

load("nnetCodegenConstants")

clear testingLabels
