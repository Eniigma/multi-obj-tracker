 function [frame,k] = displayTrackingResults(frame, tracks,confidenceThresh,ageThresh,ROI,k)

%         if ~isempty(tracks),
%             ages = [tracks(:).age]';
%             maxConfidence = tracks(:).confidence;
%             avgConfidence = tracks(:).confidence;
%             opacity = min(0.5,max(0.1,avgConfidence/3));
% %             end
% %             noDispInds = (ages < ageThresh & maxConfidence < confidenceThresh) | ...
% %                        (ages < ageThresh / 2);
%             for i = 1:length(tracks)
% %                 if isempty(noDispInds)
% %                 continue;
% %                 end
% %                 if ~noDispInds(i)
%                     % scale bounding boxes for display
%                     bb = tracks(i).bboxes(end, :);
% %                     bb(:,1:2) = (bb(:,1:2)-1)*displayRatio + 1;
% %                     bb(:,3:4) = bb(:,3:4) * displayRatio;
%                     frame = insertShape(frame, ...
%                                             'FilledRectangle', bb, ...
%                                             'Color', tracks(i).color, ...
%                                             'Opacity', opacity(i));
%                     frame = insertObjectAnnotation(frame, ...
%                                             'rectangle', bb, ...
%                                             num2str(avgConfidence(i)), ...
%                                             'Color', tracks(i).color);
%                 end
%             end
%  end
%         frame = insertShape(frame, 'Rectangle', ROI * displayRatio, ...
%                                 'Color', [255, 0, 0], 'LineWidth', 3);
                            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Convert the frame and the mask to uint8 RGB.
%         frame = im2uint8(frame);
%         minVisibleCount = 8;
        if ~isempty(tracks)

            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than
            % a minimum number of frames.
%             reliableTrackInds = ...
%                 [tracks(:).totalVisibleCount] > minVisibleCount;
%              reliableTracks = tracks(reliableTrackInds);
            reliableTracks = tracks;
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
%             if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bboxes);
%                 bboxes = reliableTracks.bboxes;
                % Get ids.
                ids = [reliableTracks(:).id];
%                 scores = [reliableTracks(:).scores];

                % Create labels for objects indicating the ones for
                % which we display the predicted rather than the actual
                % location.
                labels = cellstr(int2str(ids'));
%                 predictedTrackInds = ...
%                     [reliableTracks(:).consecutiveInvisibleCount] > 0;
%                 isPredicted = cell(size(labels));
%                 isPredicted(predictedTrackInds) = {' predicted'};
%                 labels = strcat(labels, isPredicted);

%                 l = length(reliableTracks);
%                 p = l - size(k,1);
%                 k = [k;rand(p,3)];
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels, 'LineWidth',4,'color','green');
            end
%         end
                            
                            end
    