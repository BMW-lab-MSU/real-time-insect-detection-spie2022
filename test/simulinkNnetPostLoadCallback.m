baseDir = "../../../data/insect-lidar";
testingDataDir = baseDir + filesep + "codegen-testing";

load(testingDataDir + filesep + "testingData", "testingData", "testingLabels")

testingData = nestedcell2mat(testingData);
humanLabels = nestedcell2mat(testingLabels);

load("nnetCodegenConstants")

clear testingLabels
