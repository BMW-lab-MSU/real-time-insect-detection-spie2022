% SPDX-License-Identifier: BSD-3-Clause
classdef NnetTests < matlab.unittest.TestCase
    properties (Constant)
       baseDir = "../../../data/insect-lidar/MLSP-2021";
       modelDir = NnetTests.baseDir + filesep + "training" + filesep + "models";
       dataDir = NnetTests.baseDir + filesep + "testing";
    end
    
       
    properties (TestParameter)
        data = load(NnetTests.dataDir + filesep + "testingData", 'testingFeatures').testingFeatures;
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
    end
    
    methods (TestMethodSetup)
        function loadOriginalModel(testCase)
            testCase.ogModel = load(NnetTests.modelDir + filesep + "nnet").model;
        end
        
        function unnestFeatures(testCase)
            testCase.features = nestedcell2mat(testCase.data);
        end
    end
    
    methods (Test)
        function testConvertedNetworkClassification(testCase)
            seriesNet = netToSeriesNetwork(testCase.ogModel);
            
            ogPredictions = predict(testCase.ogModel, testCase.features);
            
            seriesNetPredictions = classify(seriesNet, testCase.features);
            
            testCase.verifyIsEqual(ogPredictions, seriesNetPredictions);
        end
    end
end