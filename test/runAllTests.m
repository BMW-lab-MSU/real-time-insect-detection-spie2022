suite = testsuite;
runner = testrunner('textoutput');

tic
runInParallel(runner, suite)
toc

delete(gcp('nocreate'));