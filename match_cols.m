function offset = match_cols(imageA, imageB, refCols, searchRange)
    
    minDist = Inf;

    for i = -searchRange:searchRange
        dist = 0;
        
        for c = refCols
            dist = dist + dtw(imageA(:, c), imageB(:, c + i));
        end

        if dist < minDist
            minDist = dist;
            offset = i;
        end
    end 
    fprintf('Min distance (%d) was found %d cols ahead.\n', minDist, offset); 
end
