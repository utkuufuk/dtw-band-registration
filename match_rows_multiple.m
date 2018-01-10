function offset = match_rows_multiple(imageA, imageB, searchRange, numRefs)

    offsets = zeros(1, numRefs);

    for r = 1:numRefs
        refRowIndex = uint16(r * size(imageA, 1) / (numRefs + 1));
        minDist = Inf;
        fprintf('Searching for row %d...', refRowIndex);

        for i = (refRowIndex - searchRange):(refRowIndex + searchRange)
            dist = 0;
            dist = dist + dtw(imageA(refRowIndex, :), imageB(i, :));

            if dist < minDist
                minDist = dist;
                offsets(r) = i - refRowIndex;
            end
        end 
        fprintf('Min distance (%d) was found %d rows ahead.\n', minDist, offsets(r)); 
    end
    
    if all(~diff(offsets)) == 1
        offset = offsets(1);
    else
        e = MException('Offsetts are not identical!');
        throw(e);
    end
end
