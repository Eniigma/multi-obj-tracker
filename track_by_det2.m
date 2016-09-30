%initialization
img_ind=2;
scale = 0.6;
read_dir='F:\DDP\CODES\ped-det-master\data\road\img\';
write_dir='F:\DDP\DDP project\output'; %enter the directry where results to be written
addpath('F:\DDP\CODES\ped-det-master\ncetis\SingleTargetTracking\msdct');
% mkdir(write_dir);
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
frame = insertObjectAnnotation(frame,'rectangle',bboxes,scores,'LineWidth',4,'Color','red');
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
in_center = center;

%tracking
 bins = 16;
 h_x1=W/2;
 h_y1=H/2;
init_frame = frame; 
I = im2double(init_frame);%covert rgb image to double format
I =I*255; % to get same values in indexed image
[dctwt_q,pres_frbg,prev_frbg]=dct_wt3(I,I0,center,h_x1,h_y1);
q_u=hist_model(I,bins,center,h_x1,h_y1);

oldcenter=center;
frames=300;

trial1=zeros(frames,20);
trial2=zeros(frames,20);

for frameint=1:1:frames
    img_ind=img_ind+1;
    img_ind_prev=img_ind-1;
    %write present and previous frame
    write_frame=sprintf('%s//%d.jpeg',write_dir,img_ind);
    write_frame_prev=sprintf('%s//%d.jpeg',write_dir,img_ind_prev);
    tic;
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
    [dctwt_p,pres_frbg,prev_frbg]=dct_wt3(I,I_prev,center,h_x1,h_y1);
    %Mean Shift
    [oldcenter,bhat_coeff,p_u,w] = mean_shift_dct2(I,center,q_u,h_x1,h_y1,bins,dctwt_q,dctwt_p);
    rho = bhattacharya_coeff(q_u,p_u,bins);
    bhat_coeff_1(frameint)=rho;
    T(frameint)=toc;
    center=oldcenter;
    
    I=draw_box_r(oldcenter(1),oldcenter(2),h_x1+1,h_y1+1,I);
    I=draw_box_r(oldcenter(1),oldcenter(2),h_x1-1,h_y1-1,I);
    I=draw_box_r(oldcenter(1),oldcenter(2),h_x1,h_y1,I);
    figure(1)
    imshow(I/255);
    frameint
    imwrite(I/255,write_frame);
end
