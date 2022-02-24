latency = 1;

baseDir = "../../../data/insect-lidar";
testingDataDir = baseDir + filesep + "codegen-testing";

load(testingDataDir + filesep + "expectedLabels")

expectedLabels = expectedLabels(observationIndices);

assert(all(expectedLabels == predictedLabels(1+latency:end)), 'verification failed')
disp(['verification passed'])