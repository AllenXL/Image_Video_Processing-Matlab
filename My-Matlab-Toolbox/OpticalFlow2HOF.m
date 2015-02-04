function [HOFs,patchIdx] = OpticalFlow2HOF(flowU,flowV,patchSize,binNum)
%compute the HOF feature for each patch. The orientation of flow is
%quantized to 'binNum' bins, the magnitude is cumulated for each bin.

%flowU,flowV----two matrices of optical flow
%m,n----the whole image is split into m*n patches
%HOFs----each column is the HOF feature for each patch 
%patchIdx---- each column is the corresponding location of each patch in the image(����ÿ�������ھ����е���������)
%����ͼ���У�patch�ǰ������ң��ٴ��ϵ�������ɨ��õ���

angle=compute_angle_matrix(flowU,flowV,binNum);
magnitude=sqrt(flowU.^2+flowV.^2);

[patchIdx, patchNum] = img2patch(size(angle),patchSize,patchSize); %non-overlap patches(20*20)

HOFs=zeros(patchNum,binNum);

%compute HOF for each patch
for i=1:patchNum
    magnitudePatch=magnitude(patchIdx(i,:));
    anglePatch=angle(patchIdx(i,:));
    for j=1:binNum
        HOFs(i,j)=sum(magnitudePatch(anglePatch==j));
    end
end

%normlization
HOFs=normVector(HOFs');
patchIdx=patchIdx';

end

