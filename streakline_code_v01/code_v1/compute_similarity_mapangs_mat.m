function [smtx,streak_sim,mag_uv_sim,ang_sim] = compute_similarity_mapangs_mat(sgx,sgy,ind1,ind2,size_xx,mapped_angs,u_new,v_new,alpha)
if ~exist('alpha','var')
    alpha = [1 1 1];
end;

prj = sgx(ind1,:).*sgx(ind2,:)+sgy(ind1,:).*sgy(ind2,:);
% dff =(sgx(ind1,:)- sgx(ind2,:)).^2+(sgy(ind1,:)-sgy(ind2,:)).^2;
mag_uv = u_new.^2+v_new.^2;
mag1 = sgx(ind1,:).^2+sgy(ind1,:).^2;
mag2 = sgx(ind2,:).^2+sgy(ind2,:).^2;
% mag(:,:,1) = mag1;
% mag(:,:,2) = mag2;
% max(mag,3)
    %     max(sgx(ind1,:).*sgx(ind2,:)+sgy(ind1,:).*sgy(ind2,:),[],2);%.*su
    %     m((sgx(ind1,:)-sgx(ind2,:)).^2+(sgy(ind1,:)-sgy(ind2,:)).^2,2);
%     w=repmat(logsig(1-[0:size(prj,2)-1]),size(prj,1),1)./logsig(1);
% the_dis = sum(prj.*w./max(mag,[],3),2);
% the_dis = sum(prj./max(mag,[],3),2);
% the_dis(isnan(the_dis)) = size(prj,2);
prj = prj./sqrt(mag1.*mag2);
prj = prj./max(prj(:));
prj(isnan(prj)) = 0;
ang_sim = 1- abs(mapped_angs(ind1)-mapped_angs(ind2));
mag_uv_sim = 2-abs(mag_uv(ind1)-mag_uv(ind2))./max(mag_uv(:));
streak_sim = sum(abs(prj),2)./size(prj,2);
% the_dis = sum(dff,2).*;%sum(prj,2);
the_dis = alpha(1) * streak_sim + alpha(2) * ang_sim + alpha(3) * mag_uv_sim;
smtx = sparse(ind1,ind2,the_dis,size_xx(1)*size_xx(2),size_xx(1)*size_xx(2));
smtx = (smtx + smtx')/2;
smtx(smtx<0) = 0;
smtx(isnan(smtx)) = 0;
% hedges = smtx2hedges(smtx,1,size_xx);
% figure,imagesc(hedges)
% 'debugging'

