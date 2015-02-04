function [channels,phi,psi,w_so,w_ir] =extract_show_lanes(u_new,v_new,num_c,seg_mask)
% u_new,v_new: the flow (streak flow)
% num_c: number of expected regions with coherent motion in the frame.
% seg_mask: segmentation mask
% channels: results
% phi, psi: the potential functions
% w_so, w_ir: the solnoidal and irrotational decomposition of the flow
[phi,psi,w_so,w_ir]= compute_phi_psi(u_new,v_new);

channels =detect_psi_channels(psi,num_c);

for jm = 1:size(channels,3)
    
    %         pause
    figure
    imshow(label2rgb(seg_mask.*channels(:,:,jm)));
end;
