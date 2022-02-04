classdef KurtosisTests < matlab.unittest.TestCase

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

            data = rand(10000, 500);
            expected = kurtosis(data, 1, 2);
            result = codegenKurtosis(data);

            testCase.verifyEqual(result, expected);
        end
    end
end

