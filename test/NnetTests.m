% SPDX-License-Identifier: BSD-3-Clause
classdef NnetTests < matlab.unittest.TestCase
    properties (Constant)
       baseDir = "../../../data/insect-lidar";
       modelDir = NnetTests.baseDir + filesep + "training" + filesep + "models";
       testingDataDir = NnetTests.baseDir + filesep + "testing";
    end

    properties (TestParameter)
        testingData = load(NnetTests.testingDataDir + filesep + "testingData", 'testingFeatures').testingFeatures;
    end
    
    properties
        ogModel;
        features;
    end
    
    methods (TestClassSetup)
        function addConversionFcnToPath(testCase)
           p = path;
           testCase.addTeardown(@path, p);
           addpath('../');
        end

        function loadOriginalModel(testCase)
            testCase.ogModel = load(NnetTests.modelDir + filesep + "nnet").model;
        end
        
        function formatFeatureMatrix(testCase)
            % combine features from all images into a single table
            featuresTable = nestedcell2mat(testCase.testingData);

            % nnetInference() doesn't support tables, so convert to a matrix.
            % Plus, an FPGA can't support tables either...
            testCase.features = table2array(featuresTable);
        end
    end
    
    methods (Test)
        function testPredictedLabelsNans(testCase)
            % See if settings nans to zero returns the same predictions as 
            % leaving the nans as-is
            
            ogPredictions = predict(testCase.ogModel, testCase.features);
            
            newPredictions = false(size(ogPredictions));

            % nnetInference() doesn't support nans
            testCase.features(isnan(testCase.features)) = 0;
            
            for i = 1:height(testCase.features)
                newPredictions(i) = nnetInference(testCase.features(i,:));
            end

            testCase.verifyEqual(newPredictions, ogPredictions);
        end

        function testPredictedLabels(testCase)
            % Test if the labels match when nans are replaced with 0 for both
            % models
            
            % nnetInference() doesn't support nans
            testCase.features(isnan(testCase.features)) = 0;

            ogPredictions = predict(testCase.ogModel, testCase.features);
            
            newPredictions = false(size(ogPredictions));

            for i = 1:height(testCase.features)
                newPredictions(i) = nnetInference(testCase.features(i,:));
            end

            testCase.verifyEqual(newPredictions, ogPredictions);
        end

        function testPredictedScores(testCase)
            % Verify that the predicted posterior probabilities differ by no
            % more than 5% between the models
            
            % nnetInference() doesn't support nans
            testCase.features(isnan(testCase.features)) = 0;

            [~, ogScores] = predict(testCase.ogModel, testCase.features);
            
            newScores = zeros(size(ogScores), 'like', ogScores);

            for i = 1:height(testCase.features)
                [~, newScores(i,:)] = nnetInference(testCase.features(i,:));
            end

            testCase.verifyLessThanOrEqual(abs(newScores - ogScores), 0.05);
        end
    end
end