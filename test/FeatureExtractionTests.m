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
         function testHarmonicProductSpectrum(testCase)
             % Make sure my codegen-ready version does the same thing
             % as the original code

             % nDataPoints = 10e3;
             % dataIdx = randperm(size(testCase.data,1), nDataPoints);

             % esd = abs(fft(testCase.data(:,:)).^2);
             % esd = esd(:,1:end/2);
             % esd = esd./esd(:,1);
             psd = abs(fft(testCase.data, [], 2)).^2;
             psd = psd(:,1:end/2);
             psd = psd./psd(:,1);

             p = path;
             addpath('../original-code')

             ogHps = harmonicProductSpectrum(psd,3);

             path(p);

             newHps = harmonicProductSpectrum(psd,3);

             testCase.verifyEqual(newHps, ogHps);
         end
         function testFundamentalExtractionAgainstOriginal(testCase)
             % Make sure my codegen-ready version does the same thing
             % as the original code

             % nDataPoints = 10e3;
             % dataIdx = randperm(size(testCase.data,1), nDataPoints);

             % esd = abs(fft(testCase.data(:,:)).^2);
             % esd = esd(:,1:end/2);
             % esd = esd./esd(:,1);
             psd = abs(fft(testCase.data, [], 2).^2);
             psd = psd(:,1:end/2);
             psd = psd./psd(:,1);

             p = path;
             addpath('../original-code')

             ogFundamentals = estimateFundamentalFreq(psd);

             path(p);

             newFundamentals = estimateFundamentalFreq(psd);

             testCase.verifyEqual(newFundamentals, ogFundamentals);
         end
         function testTimeDomainFeatures(testCase)
             p = path;
             addpath('../original-code')

             ogFeaturesTbl = extractTimeDomainFeatures(testCase.data);

             ogFeatures = table2array(ogFeaturesTbl);

             path(p);

             newFeatures = extractTimeDomainFeatures(testCase.data);

             testCase.verifyEqual(newFeatures, ogFeatures);
         end
         function testPsdStats(testCase)
             psd = abs(fft(testCase.data, [], 2)).^2;
             psd = psd(:,1:end/2);
             psd = psd./psd(:,1);

             p = path;
             addpath('../original-code')

             ogFeaturesTbl = extractPsdStats(psd);
             ogFeatures = table2array(ogFeaturesTbl);

             path(p);

             newFeatures = extractPsdStats(psd);

             testCase.verifyEqual(newFeatures, ogFeatures, "AbsTol", ...
                 cast(1e-5, 'like', newFeatures));
         end
        function testHarmonicFeatures(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            import matlab.unittest.constraints.RelativeTolerance

            psd = abs(fft(testCase.data, [], 2)).^2;
            psd = psd(:,1:end/2);
            psd = psd./psd(:,1);

            p = path;
            addpath('../original-code')

            ogFeaturesTbl = extractHarmonicFeatures(psd, 3);
            ogFeatures = table2array(ogFeaturesTbl);
            ogFeatures(isnan(ogFeatures)) = 0;

            path(p);

            newFeatures = extractHarmonicFeatures(psd, 3);

            testCase.verifyThat(newFeatures, IsEqualTo(ogFeatures, 'Within',...
                AbsoluteTolerance(cast(1e-4, 'like', newFeatures)) | ...
                RelativeTolerance(cast(5e-2, 'like', newFeatures))));
        end
         function testAgainstOrginalImplementation(testCase)
             % Make sure my codegen-ready version does the same thing
             % as the original code
             import matlab.unittest.constraints.IsEqualTo
             import matlab.unittest.constraints.AbsoluteTolerance
             import matlab.unittest.constraints.RelativeTolerance

             p = path;
             addpath('../original-code')

             nDataPoints = 5e3;
             dataIdx = randperm(size(testCase.data,1), nDataPoints);
           
             ogFeaturesTbl = extractFeatures(testCase.data(dataIdx,:));

             % replace nans with 0 because the HDL version won't be
             % able to use nans
             ogFeatures = table2array(ogFeaturesTbl);
             ogFeatures(isnan(ogFeatures)) = 0;

             path(p);

             newFeatures = extractFeatures(testCase.data(dataIdx,:));

             % TODO: error tolerances need to be split by feature.
             %       The absolute errors on skewness are quite small,
             %       but the relative errors are large. The opposite is
             %       true for some of the other features, in which case a
             %       a small relative error is perfectly fine.

             % testCase.verifyEqual(newFeatures(:,1:7), ogFeatures(:,1:7),...
             %     "RelTol", cast(1e-4, 'like', newFeatures));

             % testCase.verifyEqual(newFeatures(:,8), ogFeatures(:,8),...
             %     "AbsTol", cast(1e-5, 'like', newFeatures));

             % testCase.verifyEqual(newFeatures(:,9:end), ogFeatures(:,9:end),...
             %     "RelTol", cast(1e-4, 'like', newFeatures));

             testCase.verifyThat(newFeatures, IsEqualTo(ogFeatures, ...
                 'Within', RelativeTolerance(cast(5e-2, 'like', newFeatures)) ...
                 | AbsoluteTolerance(cast(1e-4, 'like', newFeatures))));

         end
    end
end
