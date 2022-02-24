function m = codegenMedian(x)

lessThanEqCounts = zeros(size(x), 'like', x);
greaterThanCounts = zeros(size(x), 'like', x);
desiredCounts = floor(numel(x)/2);

m = cast(0, 'like', x);

for i = 1:numel(x)
    for j = 1:numel(x)
        if i ~= j
            if x(j) <= x(i)
                lessThanEqCounts(i) = lessThanEqCounts(i) + 1;
            end
        end
    end
    if lessThanEqCounts(i) == desiredCounts || lessThanEqCounts(i) == (desiredCounts - 1)
        if m == 0
            m = x(i);
        else
            % Take the average of the two median values; avoid division-by-2
            % by shifting right by 1.
            m(:) = bitsra(m + x(i), 1);
        end
    end
end
