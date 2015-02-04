function [patch_idx, patch_num] = img2patch(psize,patch_size,step_size)
%psize----image size
%patch_size----size of patch (eg.16*16)
%step_size----patch ���ص�������step_size������

%patch_idx----ÿ��Ϊһ��patch���洢���Ǹ�patch��ͼ������е�����
%patch_num----ͼ�����ܵ�patch��

if numel(patch_size)==1
    patch_size=[patch_size,patch_size];
elseif numel(patch_size)==2
    patch_size=patch_size;
else
    error('Invalid patch size!');
end
    

BlockV = floor((psize(1)-patch_size(1))/step_size+1);
BlockH = floor((psize(2)-patch_size(2))/step_size+1);

patch_num = BlockV*BlockH;
patch_idx = [];
for i=1:BlockH
    for j=1:BlockV
        temp_patch = zeros(psize(1),psize(2));
        temp_patch((j-1)*step_size+1:(j-1)*step_size+patch_size(1), (i-1)*step_size+1:(i-1)*step_size+patch_size(2)) = 1;
        temp_idx = find(temp_patch==1)';
        patch_idx = [patch_idx; temp_idx];
    end
end

