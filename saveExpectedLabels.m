% There is a bug in glibc 2.33 that causes Simulink to crash on MATLAB
% R2021a and above. Unfortunatley, Fedora 34 is using glibc 2.33, and I
% don't have time to update to Fedora 35. Thus I need to do the Simulink
% development in R2020b. However, fitcnet doesn't exist in R2020b, so I
% can't use the trained neural network in R2020b to predict labels to
% compare against the Simulink model. The workaround is to run this script
% in R2021a+, which saves the labels predicted by the network so I can
% compare those labels with the labels predicted by the Simulink model.

baseDir = "../../data/insect-lidar";
testingDataDir = baseDir + filesep + "codegen-testing";

load(testingDataDir + filesep + "testingData", "testingFeatures")

load(baseDir + "/codegen-training/models/nnet")

features = nestedcell2mat(testingFeatures);

expectedLabels = predict(model, features);

save(testingDataDir + filesep + "expectedLabels", 'expectedLabels');
