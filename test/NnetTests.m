% SPDX-License-Identifier: BSD-3-Clause
classdef NnetTests < matlab.unittest.TestCase
    properties (Constant)
       baseDir = "../../../data/insect-lidar/MLSP-2021";
       modelDir = NnetTests.baseDir + filesep + "training" + filesep + "models";
       testingDataDir = NnetTests.baseDir + filesep + "testing";
       trainingDataDir = NnetTests.baseDir + filesep + "training";
    end
    
       
    properties (TestParameter)
        testingData = load(NnetTests.testingDataDir + filesep + "testingData", 'testingFeatures').testingFeatures;
        trainingData = load(NnetTests.trainingDataDir + filesep + "trainingData", 'trainingFeatures').trainingFeatures;
    end
    
    properties
        ogModel;
        testingFeatures;
        trainingFeatures;
    end
    
    methods (TestClassSetup)
        function addConversionFcnToPath(testCase)
           p = path;
           testCase.addTeardown(@path, p);
           addpath('../');
        end
    end
    
    methods (TestMethodSetup)
        function loadOriginalModel(testCase)
            testCase.ogModel = load(NnetTests.modelDir + filesep + "nnet").model;
        end
        
        function unnestFeatures(testCase)
            testCase.testingFeatures = nestedcell2mat(testCase.testingData);
            testCase.trainingFeatures = nestedcell2mat(testCase.trainingData);
        end
    end
    
    methods (Test)
        function testConvertedNetworkClassification(testCase)

            trainingFeatures = varfun(@single, testCase.trainingFeatures);
            trainingMean = varfun(@(f) mean(f, 'omitnan'), ...
                trainingFeatures, 'OutputFormat', 'uniform');
            trainingStd = varfun(@(f) std(f,'omitnan'), ... 
                trainingFeatures, 'OutputFormat', 'uniform');

            seriesNet = netToSeriesNetwork(testCase.ogModel, trainingMean, trainingStd);
            
            ogPredictions = predict(testCase.ogModel, testCase.testingFeatures);
            
            seriesNetPredictions = classify(seriesNet, testCase.testingFeatures);

            % convert categorical labels into logical labels to match the
            % output of the original model
            seriesNetPredictionsLogical = seriesNetPredictions == 'true';
            
            testCase.verifyEqual(seriesNetPredictionsLogical, ogPredictions);
        end
    end
end