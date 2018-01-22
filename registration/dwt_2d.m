function [rowsLow, rowsHigh, colsLow, colsHigh] = dwt_2d(image)

    numRows = size(image, 1);
    numCols = size(image, 2);
    
    rowsLow = zeros(numRows, numCols / 2 + 2);
    rowsHigh = zeros(numRows, numCols / 2 + 2);
    colsLow = zeros(numRows / 2 + 2, numCols);
    colsHigh = zeros(numRows / 2 + 2, numCols);
    
    for r = 1:numRows
        [rowsLow(r, :), rowsHigh(r, :)] = dwt(image(r, :), 'bior2.2');
    end

    for c = 1:numCols
        [colsLow(:, c), colsHigh(:, c)] = dwt(image(:, c), 'bior2.2');
    end
end

