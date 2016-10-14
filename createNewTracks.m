function [tracks,nextId] = createNewTracks(tracks,centroids,bboxes,scores,unassignedDetections,nextId)
%         unassignedCentroids = centroids(unassignedDetections, :);
        unassignedBboxes = bboxes(unassignedDetections, :);
        unassignedScores = scores(unassignedDetections);

        for i = 1:size(unassignedBboxes, 1)
%             centroid = unassignedCentroids(i,:);
            bbox = unassignedBboxes(i, :);
            score = unassignedScores(i);

            % Create a new track.
%             if ~isnan(bbox(1))&&~isnan(bbox(2))
            newTrack = struct(...
                'id', nextId, ...
                'color', 255*rand(1,3), ...
                'bboxes', bbox, ...
                'scores', score, ...
                'age', 1, ...
                'totalVisibleCount', 1, ...
                'confidence', [score, score], ...
                'dctwt',10, ...
                'q_u',[]);
%                 'predPosition', bbox);

            % Add it to the array of tracks.
            tracks(end + 1) = newTrack; %#ok<AGROW>
            % Increment the next id.
            nextId = nextId + 1;
%             end
        end
    end