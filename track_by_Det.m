%aggregate channel features && mean shift dct tracker
%Initialization
% read_dir = 'F:\DDP\DDP project\school1\school1.avi';
read_dir = 'F:\DDP\CODES\ped-det-master\data\school\school.avi';
write_dir='F:\DDP\DDP project\output';
addpath('F:\DDP\DDP project\Util Funtions');
index = 1;
f_thresh = 0.16;
scale=0.67;

%input video
a = VideoReader(read_dir,'CurrentTime',0);
height = a.Height;
width = a.Width;
i=1;
while hasFrame(a)
s(i).cdata = readFrame(a);
i=i+1;
end
FrameLength = 2*i;   %No of Frames
frame = s(1).cdata;
frame = imresize(frame,scale);

%detections
[bboxes,scores] = detectPeopleACF(frame);
if scores ~=0
frame = insertObjectAnnotation(frame,'rectangle',bboxes,scores,'LineWidth',4,'Color','green');
figure(1);
imshow(frame);
title('Detected people and detection scores');
end
[~,ind] = max(scores);
W = bboxes(ind,3);
H = bboxes(ind,4);
c1= bboxes(ind,1)+W/2;
c2= bboxes(ind,2)+H/2;
center = [c1,c2];

%tracker
T = frame(round(c2-H/2):round(c2+H/2),round(c1-W/2):round(c1+W/2),:);
% frame = drawbox(c1,c2,H,W,frame);
bbox = [c1-W/2, c2-H/2, W, H];
frame = insertObjectAnnotation(frame,'rectangle',bbox,1,'LineWidth',4,'Color','green');
figure(1);
imshow(frame);
%%Target histogram 
[k,gx,gy] = Kernel(H,W,1);
[I,map] = rgb2ind(frame,65536);
Lmap = length(map)+1;
T = rgb2ind(T,map);
[dct_target] = DCT(frame, W/2,H/2,center);
q1 = PDF(T,Lmap,k,H,W);
q = dct_target*q1;
f_old = zeros(1,(FrameLength-1)*2);
f_indx = 1;
for t=index:FrameLength-1
%     frame = readFrame(a);
frame = s(t+1).cdata;
    frame = imresize(frame,scale);
    [x,y,f_old,f_indx] = MeanShift(q,frame,f_thresh,center,H,W,k,gx,gy,f_old,f_indx,map);
    center = [x y];
%     frame = drawbox(center(1),center(2),H,W,frame);
bbox = [center(1)-W/2, center(2)-H/2, W, H];
frame = insertObjectAnnotation(frame,'rectangle',bbox,1,'LineWidth',4,'Color','green');
figure(1);
imshow(frame);
%%write to directory
write_frame=sprintf('%s//%d.jpeg',write_dir,t+1);
fprintf('frame = %d \n' ,t+1);
imwrite(frame,write_frame);
end
