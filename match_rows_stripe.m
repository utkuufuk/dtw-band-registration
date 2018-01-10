function offset = match_rows_stripe(imageA, imageB, searchRange, stripeSpan)

    middleRowIndex = size(imageA, 1) / 2;
    minDist = Inf;

    for i = (middleRowIndex - searchRange):(middleRowIndex + searchRange)

        dist = 0;
        
        for s = -stripeSpan:stripeSpan
            dist = dist + dtw(imageA(middleRowIndex + s, :), imageB(i + s, :));
        end

        if dist < minDist
            minDist = dist;
            offset = i - middleRowIndex;
        end
    end

    fprintf('Min distance (%d) was found %d rows ahead.\n', minDist, offset);
end
