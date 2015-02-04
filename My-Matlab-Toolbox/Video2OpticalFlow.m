%compute the optical flow for the whole video 

clc;clear;close all;
dataPath='data\UMN1.avi';
savePath='features\HOF\';
addpath('F:\MatlabScript\¹âÁ÷\optic-flow');

mov=VideoReader(dataPath);
frmNum=401;%mov.NumberOfFrames;

Flows_U=zeros(mov.Height,mov.Width,frmNum-1);
Flows_V=zeros(mov.Height,mov.Width,frmNum-1);
Flows_Angle=zeros(mov.Height,mov.Width,frmNum-1);
Flows_Magnitude=zeros(mov.Height,mov.Width,frmNum-1);

for i=1:frmNum-1
    fprintf('compute optical flows for frame %d...\n',i);
    frmCur=double(rgb2gray(read(mov,i)));
    frmNext=double(rgb2gray(read(mov,i+1)));
    [u,v]=HornSchunck(frmCur,frmNext);
    Flows_U(:,:,i)=u;
    Flows_V(:,:,i)=v;
end

save(strcat(savePath,'Flows_U.mat'),'Flows_U');
save(strcat(savePath,'Flows_V.mat'),'Flows_V');





