function band = shift_image(panRowsLow, panColsLow, bandRowsLow, bandColsLow, band, refRows, refCols, searchRange)
    
    % shift rows
    rowOffset = match_rows(panRowsLow, bandRowsLow, refRows, searchRange);
    band = circshift(band, -rowOffset, 1);
    bandColsLow = circshift(bandColsLow, -rowOffset, 1);

    % shift columns
    colOffset = match_cols(panColsLow, bandColsLow, refCols, searchRange);
    band = circshift(band, -colOffset, 2);
end

