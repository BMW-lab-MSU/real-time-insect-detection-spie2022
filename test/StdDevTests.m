classdef StdDevTests < matlab.unittest.TestCase

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

            data = rand(10, 5);
            expected = std(data, 0, 2);
            result = stddev(data, mean(data, 2));

            testCase.verifyEqual(result, expected);

        end
    end
end
