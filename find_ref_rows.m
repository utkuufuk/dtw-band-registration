function refRows = find_ref_rows(image, numRefRows, margin)

    numRows = size(image, 1);
    numCols = size(image, 2);

    low = zeros(numRows - 2 * margin, (numCols / 2) + 2);
    high = zeros(numRows - 2 * margin, (numCols / 2) + 2);

    for r = margin + 1:numRows - margin
        [low(r, :), high(r, :)] = dwt(image(r, :), 'bior2.2');
    end

    rowFreqs = sum(abs(high), 2);
    [~, indices] = sort(rowFreqs,'descend');
    refRows = indices(1:numRefRows);
end