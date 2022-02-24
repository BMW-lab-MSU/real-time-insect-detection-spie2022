baseDir = "../../data/insect-lidar";
testingDataDir = baseDir + filesep + "codegen-testing";

load(testingDataDir + filesep + "testingData", "testingData", "testingLabels")

data = nestedcell2mat(testingData);
humanLabels = nestedcell2mat(testingLabels);

insectLabels = find(humanLabels);

load("nnetCodegenConstants")

clear testingLabels
clear testingData
