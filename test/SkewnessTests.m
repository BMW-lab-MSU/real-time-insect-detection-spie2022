classdef SkewnessTests < matlab.unittest.TestCase

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
            expected = skewness(data, 1, 2);
            result = codegenSkewness(data);

            % The very large majority of the results are within
            % 2*eps (twice the precision of doubles) of the expected
            % answers. Being off by a few times the machine precision
            % is no big deal.
            testCase.verifyEqual(result, expected, ...
                "RelTol", 3*eps(class(result)));
        end
    end
end

