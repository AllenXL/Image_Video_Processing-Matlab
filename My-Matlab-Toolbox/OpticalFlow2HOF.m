function [HOFs,patchIdx] = OpticalFlow2HOF(flowU,flowV,patchSize,binNum)
%compute the HOF feature for each patch. The orientation of flow is
%quantized to 'binNum' bins, the magnitude is cumulated for each bin.

%flowU,flowV----two matrices of optical flow
%m,n----the whole image is split into m*n patches
%HOFs----each column is the HOF feature for each patch 
%patchIdx---- each column is the corresponding location of each patch in the image(包含每个像素在矩阵中的线性索引)
%整幅图像中，patch是按从左到右，再从上到下依次扫描得到的

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

