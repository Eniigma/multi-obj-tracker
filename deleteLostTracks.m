 function [tracks] = deleteLostTracks(frame,tracks)
        if isempty(tracks)
            return;
        end
        % Compute the fraction of the track's age for which it was visible.
%         ages = [tracks(:).age]';
%         totalVisibleCounts = [tracks(:).totalVisibleCount]';
%         visibility = totalVisibleCounts ./ ages;

        % Check the maximum detection confidence score.
%         confidence = reshape([tracks(:).confidence], 2, [])';
%         maxConfidence = confidence(:, 1);

        % Find the indices of 'lost' tracks.
%         lostInds = (ages <= ageThresh & visibility <= visThresh);

        % Delete lost tracks.
%         tracks = tracks(~lostInds);

%     number = size(unassignedTracks, 1);
% for i = 1:number
%     trackIdx = unassignedTracks(i, 1);
%     tracks = tracks(~trackIdx);
% end
    [sizex,sizey,sizez] = size(frame);
    p = length(tracks);
    trackIdx = [];
    for i = 1:p
    bbox = tracks(i).bboxes;
    x1 =  bbox(1);
    x2 = bbox(1) + bbox(3);
    if (x1 < 3 || x2 > sizey-3)
        trackIdx = cat(1,trackIdx,i);
    end
    end
    tracks(trackIdx) = [];
 end