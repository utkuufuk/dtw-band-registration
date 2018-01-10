function refCols = find_ref_cols(image, numRefCols)

    numRows = size(image, 1);
    numCols = size(image, 2);

    low = zeros((numRows / 2) + 2, numCols);
    high = zeros((numRows / 2) + 2, numCols);

    for c = 1:numCols
        [low(:, c), high(:, c)] = dwt(image(:, c), 'bior2.2');
    end

    colFreqs = sum(abs(high), 1);
    [~, indices] = sort(colFreqs,'descend');
    refCols = indices(1:numRefCols);
end