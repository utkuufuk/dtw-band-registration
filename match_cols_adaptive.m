function offset = match_cols_adaptive(imageA, imageB, searchRange, refColIdx)

    minDist = Inf;

    for i = (refColIdx - searchRange):(refColIdx + searchRange)

        dist = 0;
        dist = dist + dtw(imageA(:, refColIdx), imageB(:, i));

        if dist < minDist
            minDist = dist;
            offset = i - refColIdx;
        end
    end

    fprintf('Min distance (%d) was found %d cols ahead.\n', minDist, offset);
end

