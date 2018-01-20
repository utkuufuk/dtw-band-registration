function refCols = find_ref_cols(dwtHigh, numRefCols, margin, resolution)
    startCol = margin + 1;
    endCol = size(dwtHigh, 2) - margin;
    colFreqs = sum(abs(dwtHigh(:, startCol:endCol)), 1);
    
    for c = 1:size(dwtHigh, 2)
       if rem(c, resolution) ~= 0
           colFreqs(c) = 0;
       end
    end
    
    [~, indices] = sort(colFreqs, 'descend');
    refCols = indices(1:numRefCols) + margin;
end