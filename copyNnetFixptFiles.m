% Copy the fixed point files that were generated for nnetInference(). 

% 'f' will overwrite pre-existing files
copyfile('codegen/nnetInference/fixpt/nnetInference_fixpt.m', '.', 'f')

% We need to use the mex file during unit tests because the non-mex wrapper file
% is incredibly slow... fixed point operations are painfully slow in MATLAB.
copyfile('codegen/nnetInference/fixpt/nnetInference_wrapper_fixpt_mex.*', '.', 'f')