classdef HdlFFTTests < matlab.unittest.TestCase

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
            data = rand(FFT_LENGTH, 1);
            expected = fft(data);
            result = hdlfft(data);

            testCase.verifyEqual(result, expected, "RelTol", 1e-6);
        end
    end
end

