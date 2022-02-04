classdef MedianAbsoluteDeviationTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testAgainstMatlabImplementation(testCase)
            % Make sure my codegen-ready version does the same thing
            % as the original code

            data = rand(200, 32);
            expected = mad(data, 1, 2);
            result = medianAbsDeviation(data);

            testCase.verifyEqual(result, expected);
        end
    end
end

