function y = hdlfft(x)
% hdlfft HDL-compatible 1024-point FFT.
%
% This was adapted from the "Create Vector-Input FFT for HDL
% Generation" example in the Mathworks documentation.
% https://www.mathworks.com/help/dsp/ref/dsp.hdlfft-system-object.html#bu7u5z4
%
% The FFT use a streaming low-latency architecture and processes
% chunks of 64 words at a time.

FFT_LENGTH = 1024;

% HDLFFT can only accept vectors of up to length 64 at one time
% when using the streaming architecture.
VECTOR_LEN = 64;

% FFT_LENGTH/VECTOR_LEN
N_CHUNKS = 16; 

% System objects need to be persistent for HDL code generation
persistent ft;
if isempty(ft)
    ft = dsp.HDLFFT('FFTLength', 1024, 'BitReversedOutput', false);
end
persistent loopCount
if isempty(loopCount)
    % Number of iterations needed to get the all the data through
    % the fft while accounting for the latency of the fft.
    loopCount = getLatency(ft, 1024, 64) + 16;
end

% HDLFFT outputs the same data type as the input, so we need to
% convert the input to complex numbers to get complex output.
xComplex = complex(x);

% Split the input into vectors of length 64 for processing in
% the HDLFFT system object
xVect = reshape(xComplex, VECTOR_LEN, N_CHUNKS);

yVect = complex(zeros(VECTOR_LEN, loopCount, 'like', x));
validOut = false(VECTOR_LEN, loopCount);

i = cast(0, 'uint8');

for loop = 1:loopCount
    % Select which 64-length portion of the signal to feed into the fft
    if mod(loop, N_CHUNKS) == 0
        i(:) = N_CHUNKS;
    else
        i(:) = mod(loop, N_CHUNKS);
    end

    % Input data is only valid until we reach the last 64-length
    % portion of the input signal. After that, the input data is 
    % invalid, but we need the extra computation cycles to get
    % the output data out of the fft due to the latency.
    validIn = loop <= N_CHUNKS;
    [yVect(:,loop), validOut(loop)] = ft(xVect(:,i), validIn);
end

% Grab the valid output data and flatten it back into a column vector
yValid = yVect(:,validOut==1);
y = yValid(:);