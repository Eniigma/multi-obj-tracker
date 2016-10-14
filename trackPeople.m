  function [tracks] = trackPeople(frame,frame_prev,tracks,target_update)
        for i = 1:length(tracks)
            % Get the last bounding box on this track.
%             objectHSV = rgb2hsv(frame); 
            bbox = tracks(i).bboxes;
%             tracker = vision.HistogramBasedTracker;
%             initializeObject(tracker, objectHSV(:,:,1) ,bbox);
%             dctwt = tracks(i).dctwt_q;
%             Predict the current location of the track.
            dctwt = tracks(i).dctwt;
            q_u = tracks(i).q_u;
            [trackedCentroid,dctwt,q_u,rho] = meanshift_dct(frame,frame_prev,bbox,dctwt,q_u,target_update);
%             bbox = step(tracker, hsv(:,:,1)); 
            % Shift the bounding box so that its center is at the predicted location.
%             tracks(i).predPosition = [trackedCentroid - bbox(3:4)/2, bbox(3:4)];
            tracks(i).bboxes = [trackedCentroid - bbox(3:4)/2, bbox(3:4)];
            tracks(i).dctwt = dctwt;
            tracks(i).q_u = q_u;
%             fprintf('%d',rho);
        end
    end