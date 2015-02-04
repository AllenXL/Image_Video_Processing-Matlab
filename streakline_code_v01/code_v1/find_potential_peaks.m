function [ind,ind_phi,ind_psi]=find_potential_peaks(phi,psi,w)
if nargin < 3
    
    w = .125;
end;
bw_phi = (imregionalmax(abs(phi)));
bw_psi = (imregionalmax(abs(psi)));

[ind_phi]= find(bw_phi);
[ind_psi]= find(bw_psi);


[mxval,ind2 ]=max(phi(:).^2);

ind_phi(phi(ind_phi).^2<w*mxval) = [];

[mxval,ind3 ]=max(psi(:).^2);
ind_psi(psi(ind_psi).^2<w*mxval) = [];

ind = union(ind_phi,ind_psi);