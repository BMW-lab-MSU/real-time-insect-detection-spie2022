function y = hdlfft(x)
% hdlfft HDL-compatible 1024-point FFT.
%
% This was adapted from the "Create Vector-Input FFT for HDL
% Generation" example in the Mathworks documentation.
% https://www.mathworks.com/help/dsp/ref/dsp.hdlfft-system-object.html#bu7u5z4
%
% The FFT use a streaming low-latency architecture and processes
% chunks of 64 words at a time.

%#codegen

FFT_LENGTH = 1024;

% HDLFFT can only accept vectors of up to length 64 at one time
% when using the streaming architecture.
VECTOR_LEN = 64;

% FFT_LENGTH/VECTOR_LEN
N_CHUNKS = 16; 

% persistent loopCount
% if isempty(loopCount)
%     % Number of iterations needed to get the all the data through
%     % the fft while accounting for the latency of the fft.
%     loopCount = getLatency(ft, 1024, 64) + 16;
%     % loop count = 131
% end

% HDLFFT outputs the same data type as the input, so we need to
% convert the input to complex numbers to get complex output.
xComplex = complex(x);

y = complex(zeros(size(x), 'like', x));

% Split the input into vectors of length 64 for processing in
% the HDLFFT system object
xVect = reshape(xComplex, 64, 16);

yVect = complex(zeros(64, 131, 'like', x));
validOut = false(131, 1);

yValid = complex(zeros(size(xVect), 'like', xVect));


i = cast(0, 'uint8');
j = cast(1, 'uint8');

for loop = 1:131
    % Select which 64-length portion of the signal to feed into the fft
    if loop >= 16
        i(:) = 16;
    else
        i(:) = loop;
    end
    % if mod(loop, N_CHUNKS) == 0
    %     i(:) = N_CHUNKS;
    % else
    %     i(:) = mod(loop, N_CHUNKS);
    % end

    % Input data is only valid until we reach the last 64-length
    % portion of the input signal. After that, the input data is 
    % invalid, but we need the extra computation cycles to get
    % the output data out of the fft due to the latency.
    validIn = loop <= 16;
    [yVect(:,loop), validOut(loop)] = internalfft(xVect(:,i), validIn);

    if validOut(loop)
        yValid(:, j) = yVect(:,loop);
        j = j + 1;
    end
end

% Grab the valid output data and flatten it back into a column vector

% yValid(:) = yVect(:,validOut==1);
y(:) = yValid(:);

end