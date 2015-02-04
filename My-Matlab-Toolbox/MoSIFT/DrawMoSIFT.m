clc;
clear;

videoPath = 'F:\VideoDataset\UMN\Crowd-Activity-All.avi';
featurePath = 'G:\anomalyDetection\features\MoSIFT\UMN_MoSIFT.mat';

mov = VideoReader(videoPath);
load(featurePath);
keys = MoSIFT;

for i = 400:mov.NumberOfFrames
    imshow(read(mov, i));
    title(num2str(i));
    hold on;
    
    idx = find(keys(:, 3) == i);
    pointsX = keys(idx, 1);
    pointsY = keys(idx, 2);
    pointsXV = keys(idx,5);
    pointsYV = keys(idx,6);
    
    plot(pointsX,pointsY, 'o', 'MarkerEdgeColor', [0 1 0], 'MarkerSize', 3);%'MarkerFaceColor','red',
    quiver(pointsX, pointsY, pointsXV, pointsYV, 1, 'r');    
    pause(0.5);
end
% saveas(gcf,strcat('C:\Users\XULONG\Desktop\datasetFrame\',num2str(frameNum),'.jpg'));