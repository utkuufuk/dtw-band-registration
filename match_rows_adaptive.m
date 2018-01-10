function offset = match_rows_adaptive(imageA, imageB, searchRange, refRowIdx)

    minDist = Inf;

    for i = (refRowIdx - searchRange):(refRowIdx + searchRange)

        dist = 0;
        dist = dist + dtw(imageA(refRowIdx, :), imageB(i, :));

        if dist < minDist
            minDist = dist;
            offset = i - refRowIdx;
        end
    end

    fprintf('Min distance (%d) was found %d rows ahead.\n', minDist, offset);
end
