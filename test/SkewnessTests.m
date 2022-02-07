classdef SkewnessTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testAgainstMatlabImplementationDoubles(testCase)
            % Make sure my codegen-ready version does the same thing
            % as the original code

            data = rand(10000, 500);
            expected = skewness(data, 1, 2);
            result = codegenSkewness(data);

            testCase.verifyEqual(result, expected, ...
                "AbsTol", eps(class(result)));
        end
        function testAgainstMatlabImplementationSingles(testCase)
            % Make sure my codegen-ready version does the same thing
            % as the original code

            data = rand(10000, 500, 'single');
            expected = skewness(data, 1, 2);
            result = codegenSkewness(data);

            testCase.verifyEqual(result, expected, ...
                "AbsTol", eps(class(result)));
        end
    end
end

