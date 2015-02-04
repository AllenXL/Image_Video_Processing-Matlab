function vaccum_inds = compute_vaccum_inds_saad_ali(u_new, v_new)

mg = u_new.^2+v_new.^2;
%     thresh = 1;
% bdz = find(mg< max(mg(:)*.01));
    [N,X]  = hist(mg(:));
    Thresh = X(2) - X(1);
% Thresh = max(mg(:)*s);
vaccum_inds = find(mg< Thresh);
