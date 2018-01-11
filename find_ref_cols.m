function refCols = find_ref_cols(image, numRefCols, margin)

    numRows = size(image, 1);
    numCols = size(image, 2);

    low = zeros((numRows / 2) + 2, numCols - 2 * margin);
    high = zeros((numRows / 2) + 2, numCols - 2 * margin);

    for c = margin + 1:numCols - margin
        [low(:, c), high(:, c)] = dwt(image(:, c), 'bior2.2');
    end

    colFreqs = sum(abs(high), 1);
    [~, indices] = sort(colFreqs,'descend');
    refCols = indices(1:numRefCols);
end