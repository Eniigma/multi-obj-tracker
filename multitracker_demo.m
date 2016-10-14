clc;
clear;
videoFile = 'F:\DDP\DATASETS\pets.mp4';
% videoFile = 'F:\DDP\CODES\ped-det-master\data\road\road.avi';
addpath('F:\DDP\DDP project\util funct 2');
addpath('F:\DDP\DDP project\msdct');
write_dir = 'F:\DDP\DDP project\output_pets2';
mkdir(write_dir);
fileID = fopen('tracks_pets.txt','w');

%variables
gatingThresh                =1;
gatingCost                  =100;
costOfNonAssignment         =20;
timeWindowSize              = 16;
confidenceThresh     = 2;                
ageThresh            = 8;                
visThresh            = 0.6; 
ROI                  = [40 95 400 140];
scale =1;
k = rand(1,3);

%%%%Initialization
obj.reader = VideoReader(videoFile);
tracks = initializeTracks(); % Create an empty array of tracks.
target_update = 0;

%%
frame_prev = readFrame(obj.reader);
frame_prev = imresize(frame_prev,scale);
[centroids, bboxes, scores] = detectPeople(frame_prev);
for i=1:size(centroids,1)
    tracks(i).bboxes = bboxes(i,:);
    tracks(i).scores = scores(i,:);
    tracks(i).id = i;
    tracks(i).color = 255*rand(1,3);
end
nextId = size(centroids,1)+1; % ID of the next track
frame =frame_prev;
tracks = trackPeople(frame,frame_prev,tracks,target_update);

%%display purpose
if ~isempty(scores)
display_frame_prev = insertObjectAnnotation(frame_prev,'rectangle',bboxes,scores,'color','green','LineWidth',4);
figure(1);
imshow(display_frame_prev);
end

while hasFrame(obj.reader)
% while target_update~=100
    frame   = readFrame(obj.reader);
    frame = imresize(frame,scale);
    target_update = target_update+1; 
    if mod(target_update, 25) == 0
    [centroids, bboxes, scores] = detectPeople(frame);
    %%display purpose
%     if ~isempty(scores)
%     display_frame1 = insertObjectAnnotation(frame,'rectangle',bboxes,scores,'color','green','LineWidth',4);
%     figure(1);
%     imshow(display_frame1);
%     end
    tracks = trackPeople(frame,frame_prev,tracks,target_update);    
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks,bboxes,centroids,gatingThresh,gatingCost,costOfNonAssignment);
    tracks = updateAssignedTracks(assignments,tracks,timeWindowSize,centroids,bboxes,scores);
%     tracks = updateUnassignedTracks(unassignedTracks,tracks,timeWindowSize);
      tracks = deleteLostTracks(frame,tracks);
    [tracks,nextId] = createNewTracks(tracks,centroids,bboxes,scores,unassignedDetections,nextId);
    else
    tracks = trackPeople(frame,frame_prev,tracks,target_update);
    tracks = deleteLostTracks(frame,tracks);
    end
    
    %% display and write frame
    [display_frame,k] = displayTrackingResults(frame,tracks,confidenceThresh,ageThresh,ROI,k);
    figure(1);
    imshow(display_frame);
    write_frame=sprintf('%s//%d.jpeg',write_dir,target_update);
    fprintf('frame = %d \n' ,target_update);
    imwrite(display_frame,write_frame);
    frame_prev = frame;
    for n=1:length(tracks)
        bbox = tracks(n).bboxes;
        id = tracks(n).id;
    fprintf(fileID,'%d %d %d %d %d %d %d %d %d %d\r\n',target_update,id,bbox(1),bbox(2),bbox(3),bbox(4),-1,-1,-1,-1);
    end
end
fclose(fileID);