function offset = match_cols_multiple(imageA, imageB, searchRange, numRefs)

    offsets = zeros(1, numRefs);

    for r = 1:numRefs
        refColIndex = uint16(r * size(imageA, 1) / (numRefs + 1));
        minDist = Inf;
        fprintf('Searching for col %d...', refColIndex);

        for i = (refColIndex - searchRange):(refColIndex + searchRange)
            dist = 0;
            dist = dist + dtw(imageA(:, refColIndex), imageB(:, i));

            if dist < minDist
                minDist = dist;
                offsets(r) = i - refColIndex;
            end
        end 
        fprintf('Min distance (%d) was found %d cols ahead.\n', minDist, offsets(r)); 
    end
    
    if all(~diff(offsets)) == 1
        offset = offsets(1);
    else
        e = MException('Offsetts are not identical!');
        throw(e);
    end
end
