function [new_seg_mask,aveUV] = colorize_seg_mask(seg_mask,u_new,v_new,PSuedoColors,COMPAVE)
if nargin<5
    COMPAVE = false;
end;
if nargin < 4
    PSuedoColors = false;
end;
flow(:,:,1) = nan2zeros(u_new);
flow(:,:,2) = nan2zeros(v_new);
optical_flow_im = flowToColor(flow);
clrs = unique(seg_mask(:));
seg_mask2 = 0*optical_flow_im;
BW = double(seg_mask*0);
line_clrs = round(lines(length(clrs))*255);
for j = 1:length(clrs)
    tmp = optical_flow_im(:,:,1);
    [r_,c_] = find(seg_mask==clrs(j));
    r_ind =sub2ind(size(seg_mask2),r_,c_,0*c_+1);
    g_ind =sub2ind(size(seg_mask2),r_,c_,0*c_+2);
    b_ind =sub2ind(size(seg_mask2),r_,c_,0*c_+3);
    tampa = seg_mask;
    tampa(seg_mask~=clrs(j)) = 0;
    tampa(seg_mask==clrs(j)) = 1;
    
    tmp = tmp(seg_mask==clrs(j));
    BW = BW + double(bwmorph(tampa,'Remove'));
    if ~PSuedoColors
        
        r = median(tmp(:));
    else
        r = line_clrs(j,1);
    end;
    
    tmp = optical_flow_im (:,:,2);
    tmp = tmp(seg_mask==clrs(j));
    if ~PSuedoColors
        g = median(tmp(:));
    else
        g = line_clrs(j,2);
    end;
    
    tmp = optical_flow_im (:,:,3);
    tmp = tmp(seg_mask==clrs(j));
    if ~PSuedoColors
        b = median(tmp(:));
    else
        b = line_clrs(j,3);
    end
    
    seg_mask2(r_ind) = r;
    
    seg_mask2(g_ind) = g;
    seg_mask2(b_ind) = b;
    if COMPAVE
        aveUV.u(r_,c_) = median(u_new(seg_mask==clrs(j)));
        aveUV.v(r_,c_) = median(v_new(seg_mask==clrs(j)));
    end;
    
end;
%     seg_mask2 = rgb2hsv(seg_mask2);
%     seg_mask2(:,:,2) = max(1+0*seg_mask2(:,:,2),2*seg_mask2(:,:,2) );
%     BW1 = EDGE(seg_mask2(:,:,1),'sobel',0);
%     BW2 = EDGE(seg_mask2(:,:,2),'sobel',0);
% BW = bwmorph(seg_mask,'Remove');

%     BW = BW1+BW2+BW3;
% [r_,c_] = find(BW>0);
% r_ind =sub2ind(size(seg_mask2),r_,c_,0*c_+1);
% g_ind =sub2ind(size(seg_mask2),r_,c_,0*c_+2);
% b_ind =sub2ind(size(seg_mask2),r_,c_,0*c_+3);
% seg_mask2(r_ind) = 180;
% 
% seg_mask2(g_ind) = 180;
% seg_mask2(b_ind) = 180;
new_seg_mask = seg_mask2;