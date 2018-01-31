function band = shift_image(panRowsLow, panColsLow, rowsLow, colsLow, band, refRows, refCols, rowRange, colRange)
    
    % shift rows
    rowOffset = match_rows(panRowsLow, rowsLow, refRows, rowRange);
    band = circshift(band, -rowOffset, 1);
    colsLow = circshift(colsLow, -rowOffset, 1);

    % shift columns
    colOffset = match_cols(panColsLow, colsLow, refCols, colRange);
    band = circshift(band, -colOffset, 2);
end

