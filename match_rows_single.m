function offset = match_rows_single(imageA, imageB, searchRange)

    middleRowIndex = size(imageA, 1) / 2;
    minDist = Inf;

    for i = (middleRowIndex - searchRange):(middleRowIndex + searchRange)

        dist = 0;
        dist = dist + dtw(imageA(middleRowIndex, :), imageB(i, :));

        if dist < minDist
            minDist = dist;
            offset = i - middleRowIndex;
        end
    end

    fprintf('Min distance (%d) was found %d rows ahead.\n', minDist, offset);
end
