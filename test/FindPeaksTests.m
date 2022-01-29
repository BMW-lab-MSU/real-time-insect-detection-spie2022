classdef FindPeaksTests < matlab.unittest.TestCase

    methods (TestClassSetup)
        function addToPath(testCase)
            p = path;
            testCase.addTeardown(@path, p);
            addpath('../');
        end
    end

    methods (Test)
        function testAgainstMatlabImplementationSimpleVector(testCase)
            % From MATLAB findpeaks documentation; modified so there isn't a plateau 
            data = [25 8 15 5 6 10 3 1 20 7];

            [expectedHeights, expectedLocations] = findpeaks(data);

            [heights, locations, ~, ~] = findPeaks(data);

            testCase.verifyEqual(heights, expectedHeights);
            testCase.verifyEqual(double(locations), double(expectedLocations));
        end
        function testAgainstMaltabImplementationGaussianMixture(testCase)
            % From MATLAB findpeaks documentation
            x = linspace(0,1,1000);

            Pos = [1 2 3 5 7 8]/10;
            Hgt = [3 4 4 2 2 3];
            Wdt = [2 6 3 3 4 6]/100;

            for n = 1:length(Pos)
                Gauss(n,:) = Hgt(n)*exp(-((x - Pos(n))/Wdt(n)).^2);
            end

            PeakSig = sum(Gauss);

            [expectedHeights, expectedLocations, expectedWidths, expectedProminences] = findpeaks(PeakSig);

            [heights, locations, widths, prominences] = findPeaks(PeakSig);

            testCase.verifyEqual(heights, expectedHeights);
            testCase.verifyEqual(double(locations), double(expectedLocations));
            testCase.verifyEqual(widths, expectedWidths);
            testCase.verifyEqual(prominences, expectedProminences);
        end
        % function testOddPlateau(testCase)
        %     % MATLAB's findpeaks does not find the midpoint of the plateau, but scipy's implementation does (which I what I translated). This test case is to make sure the findPeaks returns the plateau's midpoint.
        %     data = [25 8 15 5 6 10 10 10 3 1 20 2];

        %     expectedLocations = [3 7 11];

        %     [~, locations, ~, ~] = findPeaks(data);

        %     testCase.verifyEqual(double(locations), double(expectedLocations));
        % end
        % function testEvenPlateau(testCase)
        %     % MATLAB's findpeaks does not find the midpoint of the plateau, but scipy's implementation does (which I what I translated). This test case is to make sure the findPeaks returns the plateau's midpoint.
        %     data = [25 8 15 5 6 10 10 10 10 3 1 20 2];

        %     expectedLocations = [3 8 12];

        %     [~, locations, ~, ~] = findPeaks(data);

        %     testCase.verifyEqual(double(locations), double(expectedLocations));
        % end
        function testEndPoints(testCase)
            % Neither end point can be a maxima
            data = [25 8 15 5 6 10 3 1 20 25];

            expectedLocations = [3 6];

            [~, locations, ~, ~] = findPeaks(data);

            testCase.verifyEqual(double(locations), double(expectedLocations));
        end
    end
end
