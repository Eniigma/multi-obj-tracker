clear classes;
%% Instantiate video device, detector, and KLT object tracker
read_dir = 'F:\DDP\CODES\ped-det-master\data\mandi\mandi.avi';
write_dir = 'F:\DDP\DDP project\output_test1';
vidObj = VideoReader(read_dir);

% faceDetector = vision.CascadeObjectDetector(); % Finds faces by default
tracker = MultiObjectTrackerKLT;

%% Get a frame for frame-size information
frame = readFrame(vidObj);
frameSize = size(frame);

%% Create a video player instance
videoPlayer  = vision.VideoPlayer('Position',[200 100 fliplr(frameSize(1:2)+30)]);

%% Iterate until we have successfully detected a face
bboxes = [];
while isempty(bboxes)
    frame = readFrame(vidObj);
    framergb = frame;
    %     frame = rgb2gray(framergb);
    [bboxes,~] = detectPeopleACF(frame);
    frame = rgb2gray(frame);
end
tracker.addDetections(frame, bboxes);

%% And loop until the player is closed
frameNumber = 0;
while hasFrame(vidObj)

    framergb = readFrame(vidObj);
    frame = rgb2gray(framergb);
    
    if mod(frameNumber, 10) == 0
        % (Re)detect faces.
        %
        % NOTE: face detection is more expensive than imresize; we can
        % speed up the implementation by reacquiring faces using a
        % downsampled frame:
        % bboxes = faceDetector.step(frame);
%     temp = imresize(framergb,0.5);
    [bboxes,~] = detectPeopleACF(framergb);
    if ~isempty(bboxes)
            tracker.addDetections(frame, bboxes);
    end
    else
        % Track faces
        tracker.track(frame);
    end
    % Display bounding boxes and tracked points.
    displayFrame = insertObjectAnnotation(framergb, 'rectangle',...
        tracker.Bboxes, tracker.BoxIds, 'LineWidth',3);
    displayFrame = insertMarker(displayFrame, tracker.Points);
    write_frame=sprintf('%s//%d.jpeg',write_dir,frameNumber+1);
    imwrite(displayFrame,write_frame);
    videoPlayer.step(displayFrame);
    
    frameNumber = frameNumber + 1;
end

%% Clean up
release(videoPlayer);