latency = 1;

baseDir = "../../../data/insect-lidar";

load(baseDir + "/codegen-training/models/nnet")

expectedLabels = predict(model, inputFeatures);

assert(all(expectedLabels == predictedLabels(1+latency:end)), 'verification failed')
disp(['verification passed'])
