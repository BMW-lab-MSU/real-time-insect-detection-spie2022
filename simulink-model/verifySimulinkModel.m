latency = 2;

baseDir = "../../../data/insect-lidar";
testingDataDir = baseDir + filesep + "codegen-testing";

load(testingDataDir + filesep + "expectedLabels")

expectedLabels = expectedLabels(observationIndices);

predictedLabels = predictedLabels(1+latency:end);

mismatches = expectedLabels ~= predictedLabels;

if any(mismatches)
    disp('different predictions at these indices:')
    disp(find(mismatches))
else
    disp('verification passed')
end

save(testingDataDir + filesep + "labelMismatches", 'predictedLabels', 'expectedLabels', 'mismatches')
