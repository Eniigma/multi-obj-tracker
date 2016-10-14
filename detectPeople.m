function [centroids,bboxes,scores] = detectPeople(frame)
% [bboxes,scores] = detectPeopleACF(frame,'Model','caltech-50x21');
[bboxes,scores] = detectPeopleACF(frame);
   % Apply non-maximum suppression to select the strongest bounding boxes.
%         [bboxes, scores] = selectStrongestBbox(bboxes, scores, ...
%                             'RatioType', 'Min', 'OverlapThreshold', 0.6);

        % Compute the centroids
        if isempty(bboxes)
            centroids = [];
        else
            centroids = [(bboxes(:, 1) + bboxes(:, 3) / 2), ...
                (bboxes(:, 2) + bboxes(:, 4) / 2)];
        end
end