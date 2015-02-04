function F = phi2peaks(phi,ratio)
% phi : 2D the potential field (phi or psi)
% ratio: [0 1] ratio to define the treshold for picking the extremas.
%               ratio=0 means all of the regional peaks are selected. ratio =.99 means
%               only the highest peak is selected.
% F : The peaks' coordinates, areas, and values as the signature of the
%     potential field ( Nx4 matrix where N is the number of peaks)
%     F = [index,x,y,peak_value]
%
%
% Written by Ramin Mehran in Vision lab at UCF @ 11/12/2009

phi2 = phi.^2;
phi3 = phi-min(min(phi));
phi3 = phi3/max(phi3(:))*255;

BW=imregionalmax(phi3);
BW2 = imregionalmin(phi3);
[ind_phi]= find(BW+BW2);

[mxval,ind2 ]=max(phi3(:));

ind_phi(phi2(ind_phi)<ratio*mxval) = [];

[r,c] = ind2sub(size(phi),ind_phi);

F = [ind_phi,c,r,phi(ind_phi)];