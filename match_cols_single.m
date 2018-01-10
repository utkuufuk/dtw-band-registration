function offset = match_cols_single(imageA, imageB, searchRange)

    middleColIndex = size(imageA, 2) / 2;
    minDist = Inf;

    for i = (middleColIndex - searchRange):(middleColIndex + searchRange)

        dist = 0;
        dist = dist + dtw(imageA(:, middleColIndex), imageB(:, i));

        if dist < minDist
            minDist = dist;
            offset = i - middleColIndex;
        end
    end

    fprintf('Min distance (%d) was found %d cols ahead.\n', minDist, offset);
end

