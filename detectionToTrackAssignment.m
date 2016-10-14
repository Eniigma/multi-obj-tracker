 function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment(tracks,bboxes,centroids,gatingThresh,gatingCost,costOfNonAssignment)

    predBboxes = reshape([tracks(:).bboxes], 4, [])';
% predBboxes = tracks(:).bboxes;      
cost = 1 - bboxOverlapRatio(predBboxes, bboxes);

        % Force the optimization step to ignore some matches by
        % setting the associated cost to be a large number. Note that this
        % number is different from the 'costOfNonAssignment' below.
        % This is useful when gating (removing unrealistic matches)
        % technique is applied.
        cost(cost > gatingThresh) = 1 + gatingCost;
      
%          nTracks = length(tracks);
%         nDetections = size(centroids, 1);

        % Compute the cost of assigning each detection to each track.
%         cost = zeros(nTracks, nDetections);
        
%         for i = 1:nTracks
%             bbox = tracks(i).bboxes;
%             center = bbox(1:2)+ bbox(3:4)/2; 
%             cost(i, :) = distance(center, centroids);
%         end
        % Solve the assignment problem.
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);
    end