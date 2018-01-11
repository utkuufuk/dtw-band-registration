function offset = match_rows(imageA, imageB, refRows, searchRange)
    
    minDist = Inf;

    for i = -searchRange:searchRange
        dist = 0;
        
        for r = refRows
            dist = dist + dtw(imageA(r, :), imageB(r + i, :));
        end

        if dist < minDist
            minDist = dist;
            offset = i;
        end
    end 
    fprintf('Min distance (%d) was found %d rows ahead.\n', minDist, offset); 
end
