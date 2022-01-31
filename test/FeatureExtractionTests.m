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

            ogFeaturesTbl = extractFeatures(testCase.data(1:5000,:));

            % replace nans with 0 because the HDL version won't be
            % able to use nans
            ogFeatures = table2array(ogFeaturesTbl);
            ogFeatures(isnan(ogFeatures)) = 0;

            path(p);

            newFeatures = extractFeatures(testCase.data(1:5000,:));

            testCase.verifyEqual(newFeatures, ogFeatures,...
                "RelTol", cast(1e-2, 'like', newFeatures));
        end
        function testFundamentalExtractionAgainstOriginal(testCase)
            % Make sure my codegen-ready version does the same thing
            % as the original code

            esd = abs(fft(testCase.data(1:5000,:)).^2);
            esd = esd(:,1:end/2);
            esd = esd./esd(:,1);

            p = path;
            addpath('../original-code')

            ogFundamentals = estimateFundamentalFreq(esd);

            path(p);

            newFundamentals = estimateFundamentalFreq(esd);

            testCase.verifyEqual(newFundamentals, ogFundamentals);
        end
    end
end
