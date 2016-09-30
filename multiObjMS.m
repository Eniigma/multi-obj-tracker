clc;
clear all;
%multiple target tracking mean shift
%initialization
bins = 16;
img_ind=2;
scale = 0.6;
read_dir='F:\DDP\CODES\ped-det-master\data\road\img\';
write_dir='F:\DDP\DDP project\output'; %enter the directry where results to be written
addpath('F:\DDP\DDP project\msdct');
frame=sprintf('%s%08d.jpg',read_dir,img_ind-1);
zeroeth_frame = imread(frame);
zeroeth_frame = imresize(zeroeth_frame,scale);
I0 = im2double(zeroeth_frame);%covert rgb image to double format
I0 =I0*255; % to get same values in indexed image
%1st Frame
init_frame=sprintf('%s%08d.jpg',read_dir,img_ind);
frame = imread(init_frame);
frame = imresize(frame,scale);

%detections
[bboxes,scores] = detectPeopleACF(frame);
if scores ~=0
annotedframe = insertObjectAnnotation(frame,'rectangle',bboxes,scores,'LineWidth',4,'Color','green');
figure(1);
imshow(annotedframe);
title('Detected people and scores');
end

%tracking
center(:,1) = bboxes(:,1)+ bboxes(:,3)/2;  %% Centroid values
center(:,2) = bboxes(:,2)+ bboxes(:,4)/2;
in_center = center;
nObjects = size(center,1); % no of detected objects
init_frame = frame; 
I = im2double(init_frame);%covert rgb image to double format
I =I*255; % to get same values in indexed image

dctwt_target = zeros(nObjects);
q_u = zeros(nObjects,16,16,16);
for j = 1:nObjects
temp_center = center(j,:);
hx = bboxes(j,3)/2;
hy = bboxes(j,4)/2;
[dctwt_q,pres_frbg,prev_frbg]=dct_wt3(I,I0,temp_center,hx,hy);
dctwt_target(j) = dctwt_q; 
temp = hist_model(I,bins,temp_center,hx,hy);
q_u(j,:,:,:) = temp;
end
oldcenter=center;
nframes=200;
trial1=zeros(nframes,20);
trial2=zeros(nframes,20);

for frameint=1:1:nframes
    if mod(frameint,10) == 0
    [bboxes1,scores1] = detectPeopleACF(init_frame);
    if scores1 ~=0
    scores = scores1;
    bboxes = bboxes1;
    nObjects = size(bboxes,1);
    annotedframe = insertObjectAnnotation(init_frame,'rectangle',bboxes,scores,'LineWidth',4,'Color','green');
    figure(1);
    imshow(annotedframe);
    title('Detections');
    else
    img_ind=img_ind+1;
    img_ind_prev=img_ind-1;
    %write present and previous frame
    write_frame=sprintf('%s//%d.jpeg',write_dir,img_ind);
    write_frame_prev=sprintf('%s//%d.jpeg',write_dir,img_ind_prev);
    read_frame=sprintf('%s%08d.jpg',read_dir,img_ind);
    read_frame_prev=sprintf('%s%08d.jpg',read_dir,img_ind_prev);
    init_frame = imread(read_frame);
    init_frame = imresize(init_frame,scale);
    prev_frame=imread(read_frame_prev);
    prev_frame = imresize(prev_frame,scale);
    I = im2double(init_frame);
    I = I*255;    
    I_prev = im2double(prev_frame);
    I_prev = I_prev*255;
  for j = 1:nObjects
    temp_center = center(j,:);
    hx = bboxes(j,3)/2;
    hy = bboxes(j,4)/2;
    dctwt_q = dctwt_target(j);
    q_target(:,:,:) = q_u(j,:,:,:);
    [dctwt_p,pres_frbg,prev_frbg]=dct_wt3(I,I_prev,temp_center,hx,hy);
    [oldcenter,bhat_coeff,p_u,w] = mean_shift_dct2(I,temp_center,q_target,hx,hy,bins,dctwt_q,dctwt_p);
    center(j,:) = oldcenter;
  end
    end
    else
    img_ind=img_ind+1;
    img_ind_prev=img_ind-1;
    %write present and previous frame
    write_frame=sprintf('%s//%d.jpeg',write_dir,img_ind);
    write_frame_prev=sprintf('%s//%d.jpeg',write_dir,img_ind_prev);
%     tic;
    %read present and previous frame
    read_frame=sprintf('%s%08d.jpg',read_dir,img_ind);
    read_frame_prev=sprintf('%s%08d.jpg',read_dir,img_ind_prev);
    init_frame = imread(read_frame);
    init_frame = imresize(init_frame,scale);
    prev_frame=imread(read_frame_prev);
    prev_frame = imresize(prev_frame,scale);
    %Double format
    I = im2double(init_frame);
    I = I*255;    
    I_prev = im2double(prev_frame);
    I_prev = I_prev*255;
%     dctwt_candidate = zeros(nObjects);
%     p_candidate = zeros(nObjects,255,255,255);
%     rho_b = zeros(nObjects);
  for j = 1:nObjects
    temp_center = center(j,:);
    hx = bboxes(j,3)/2;
    hy = bboxes(j,4)/2;
    dctwt_q = dctwt_target(j);
    q_target(:,:,:) = q_u(j,:,:,:);
    [dctwt_p,pres_frbg,prev_frbg]=dct_wt3(I,I_prev,temp_center,hx,hy);
%     dctwt_candidate(j) = dctwt_p;
    [oldcenter,bhat_coeff,p_u,w] = mean_shift_dct2(I,temp_center,q_target,hx,hy,bins,dctwt_q,dctwt_p);
%     p_candidate(j,:,:,:) = p_u; 
%     rho = bhattacharya_coeff(q_u,p_u,bins);
%     rho_b(j) = rho; 
    center(j,:) = oldcenter;
  end
%     bhat_coeff_1(frameint)=rho;
%     T(frameint)=toc;
%     center=oldcenter;
    bboxes(:,1) = center(:,1)-bboxes(:,3)/2;
    bboxes(:,2) = center(:,2)-bboxes(:,4)/2;
    end
    Labelstr = '';
    for i = 1:nObjects
    Labelstr{i} = ['%d',i]; 
    end
    I = insertObjectAnnotation(I/255,'rectangle',bboxes,Labelstr,'LineWidth',4,'Color','green');
    figure(1)
    imshow(I);
    frameint
    imwrite(I,write_frame);
end
