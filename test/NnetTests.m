% SPDX-License-Identifier: BSD-3-Clause
classdef NnetTests < matlab.unittest.TestCase
    properties (Constant)
       baseDir = "../../../data/insect-lidar";
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
        function testInference(testCase)
            
            features = table2array(testCase.testingFeatures);
            
            features(isnan(features)) = 0;

            [ogPredictions, ogScores] = predict(testCase.ogModel, features);
            
            newPredictions = false(size(ogPredictions));
            newScores = zeros(size(ogScores), 'like', ogScores);
            
            for i = 1:height(features)
                [newPredictions(i), newScores(i,:)] = nnetInference(features(i,:));
            end

            testCase.verifyEqual(newPredictions, ogPredictions);
        end

    end
end