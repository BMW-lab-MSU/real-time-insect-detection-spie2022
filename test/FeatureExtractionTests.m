classdef FeatureExtractionTests < matlab.unittest.TestCase

    properties (Constant)
       baseDir = "../../../data/insect-lidar";
       testingDataDir = FeatureExtractionTests.baseDir + filesep + "testing";
    end

    properties
        data
    end

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
        function loadData(testCase)
            load(FeatureExtractionTests.testingDataDir + filesep + "testingData")

            % combine features from all images into a single table
            testCase.data = nestedcell2mat(testingData);
        end
    end

    methods (Test)
        function testAgainstOrginalImplementation(testCase)
            % Make sure my codegen-ready version does the same thing
            % as the original code

            p = path;
            addpath('../original-code')

            ogFeatures = extractFeatures(testCase.data(1:1000,:));

            path(p);

            newFeatures = extractFeatures(testCase.data(1:1000,:));

            testCase.verifyEqual(newFeatures, ogFeatures);
        end
    end
end
