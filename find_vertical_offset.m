function verticalOffset = find_vertical_offset(imageA, imageB, maxRows)

    middleRowIndex = size(imageA, 1) / 2;
    minDist = Inf;

    for i = (middleRowIndex - maxRows):(middleRowIndex + maxRows)

        dist = 0;
        
        for s = -1:1
            dist = dist + dtw(imageA(middleRowIndex + s, :), imageB(i + s, :));
        end

        if dist < minDist
            minDist = dist;
            verticalOffset = i - middleRowIndex;
        end
    end

    fprintf('Min distance (%d) was found %d rows ahead.\n', minDist, verticalOffset);
end
