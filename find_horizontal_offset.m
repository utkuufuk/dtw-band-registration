function horizontalOffset = find_horizontal_offset(imageA, imageB, maxCols)

    middleColIndex = size(imageA, 2) / 2;
    minDist = Inf;

    for i = (middleColIndex - maxCols):(middleColIndex + maxCols)

        dist = 0;
        
        for s = -1:1
            dist = dist + dtw(imageA(:, middleColIndex + s), imageB(:, i + s));
        end

        if dist < minDist
            minDist = dist;
            horizontalOffset = i - middleColIndex;
        end
    end

    fprintf('Min distance (%d) was found %d cols ahead.\n', minDist, horizontalOffset);
end

