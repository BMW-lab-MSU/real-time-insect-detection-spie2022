function [yOut, validOut] = internalfft(x, validIn)

% System objects need to be persistent for HDL code generation
persistent ft;
if isempty(ft)
    ft = dsp.HDLFFT('FFTLength', 1024, 'BitReversedOutput', false);
end
[yOut, validOut] = ft(x, validIn);
end
