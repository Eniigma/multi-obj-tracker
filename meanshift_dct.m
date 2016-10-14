function [centroid,dctwt_q,q_u,rho] = meanshift_dct(frame,frame_prev,bbox,dctwt_q,q_u,target_update)
    bins = 16;
    rho = 0;
    h_x1 = bbox(1,3)/2;
    h_y1 = bbox(1,4)/2;
    oldcenter = [bbox(1,1)+h_x1, bbox(1,2)+h_y1];
    centroid = oldcenter;
    I = 255*im2double(frame);    
%     I_prev = 255*im2double(frame_prev);
    if isempty(q_u)
%     [dctwt_q,~,~]=dct_wt3(I,I_prev,centroid,h_x1,h_y1);
%      if isnan(dctwt_q)
%          dctwt_q = 1;
%      end
dctwt_q =1;
    q_u=hist_model(I,bins,centroid,h_x1,h_y1);
    else
%     [dctwt_p,~,~]=dct_wt3(I,I_prev,centroid,h_x1,h_y1);
%     if isnan(dctwt_p)
%          dctwt_p = 1;
%      end
dctwt_p =1;
    [oldcenter,rho,~,~] = mean_shift_dct2(I,centroid,q_u,h_x1,h_y1,bins,dctwt_q,dctwt_p);
%     if ~isnan(oldcenter(1))&&~isnan(oldcenter(2))
    centroid = oldcenter;
%     end
    end
end