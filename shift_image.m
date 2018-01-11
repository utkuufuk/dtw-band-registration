function band = shift_image(enhancedPan, enhancedBand, band, refRows, refCols, searchRange)
    
    % shift rows
    rowOffset = match_rows(enhancedPan, enhancedBand, refRows, searchRange);
    band = circshift(band, -rowOffset, 1);
    enhancedBand = circshift(enhancedBand, -rowOffset, 1);

    % shift columns
    colOffset = match_cols(enhancedPan, enhancedBand, refCols, searchRange);
    band = circshift(band, -colOffset, 2);
end

