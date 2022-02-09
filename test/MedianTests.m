classdef MedianTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        % function testOdd(testCase)
        %     % Make sure my codegen-ready version does the same thing
        %     % as the original code

        %     data = [10 5 2 1 11];
            
        %     expected = median(data);
        %     result = codegenMedian(data);

        %     testCase.verifyEqual(result, expected);
        % end
        % function testOddDuplicate(testCase)
        %     % Make sure my codegen-ready version does the same thing
        %     % as the original code

        %     data = [10 5 2 5 11];
            
        %     expected = median(data);
        %     result = codegenMedian(data);

        %     testCase.verifyEqual(result, expected);
        % end
        % function testOddRand(testCase)
        %     % Make sure my codegen-ready version does the same thing
        %     % as the original code

        %     data = rand(1,51);
            
        %     expected = median(data);
        %     result = codegenMedian(data);

        %     testCase.verifyEqual(result, expected);
        % end
        function testEvenDuplicate(testCase)
            data = [10 5 5 2 1 11];
            
            expected = median(data);
            result = codegenMedian(data);

            testCase.verifyEqual(result, expected);
        end
        function testEven(testCase)
            data = [10 5 7 2 1 11];
            
            expected = median(data);
            result = codegenMedian(data);

            testCase.verifyEqual(result, expected);
        end
        function testEvenRand(testCase)
            data = rand(1,512);
            
            expected = median(data);
            result = codegenMedian(data);

            testCase.verifyEqual(result, expected);
        end
    end
end
