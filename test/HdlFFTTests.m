classdef HdlFFTTests < matlab.unittest.TestCase

    properties (Constant)
       baseDir = "../../../data/insect-lidar";
       testingDataDir = FeatureExtractionTests.baseDir + filesep + "testing";
    end

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testAgainstFFT(testCase)
            % Make sure my HDL codegen-ready version does the same
            % as the original fft

            FFT_LENGTH =1024;
            data = rand(FFT_LENGTH, 1, 'single');
            expected = fft(data);
            result = hdlfft(data);

            testCase.verifyEqual(result, expected, "AbsTol", single(1e-5));
        end
        function testOnLidarData(testCase)
            import matlab.unittest.constraints.IsEqualTo
            import matlab.unittest.constraints.AbsoluteTolerance
            import matlab.unittest.constraints.RelativeTolerance

            load(HdlFFTTests.testingDataDir + filesep + "testingData")
            data = nestedcell2mat(testingData);

            nDataPoints = 150e3;
            dataIdx = randperm(size(data,1), nDataPoints);
            data = data(dataIdx,:);

            expected = fft(data, [], 2);

            result = complex(zeros(size(expected), 'like', expected));
            parfor i = 1:nDataPoints
                result(i,:) = hdlfft(data(i,:).').';
            end

            testCase.verifyThat(result, IsEqualTo(expected, 'Within',...
                RelativeTolerance(single(1e-6)) | AbsoluteTolerance(single(1e-5))));
            %testCase.verifyEqual(result, expected, "AbsTol", single(1e-5));
        end
    end
end

