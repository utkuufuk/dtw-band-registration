function refRows = find_ref_rows(dwtHigh, numRefRows, margin, resolution)
    startRow = margin + 1;
    endRow = size(dwtHigh, 1) - margin;
    rowFreqs = sum(abs(dwtHigh(startRow:endRow, :)), 2);
    
    for r = 1:size(dwtHigh, 1)
       if rem(r, resolution) ~= 0
           rowFreqs(r) = 0;
       end
    end
    
    [~, indices] = sort(rowFreqs, 'descend');
    refRows = indices(1:numRefRows) + margin;
end

