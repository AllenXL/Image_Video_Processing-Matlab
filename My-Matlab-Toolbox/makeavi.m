function makeavi

dataPath = 'G:\anomalyDetection\result\scene3\';

%% use VideoWriter
% Prepare the new file.
vidObj = VideoWriter(strcat(dataPath,'result.avi'));
vidObj.Quality = 100;
vidObj.FrameRate = 20;
open(vidObj);
data = dir([dataPath '*.png']);
for i = 1:length(data)
    i
    im=imread(strcat(dataPath,num2str(i),'.png'));
    writeVideo(vidObj,uint8(im));
end

% Close the file.
close(vidObj);

end

%% use avifile
% %================设置相关属性======================
% 
% aviObj=avifile(strcat(resultPath,'result.avi')); % Create a new AVI file
% 
% aviObj.Quality = 100;  %只对压缩格式有效，[0,100],default:75
% 
% aviObj.fps=25;    %the speed of the AVI movie in frames per second (fps),default:15 fps
% 
% aviObj.Compression='Indeo5';  % compression codec指定压缩编解码器
% 
% %=======设置黑白图像属性===========
% 
% % cola=0:1/255:1;   
%   
% % cola=[cola;cola;cola];
% % 
% % cola=cola';
% % 
% % aviobj.colormap=cola;
% 
% % =====多帧循环开始,读序列图像=================
% data=dir([dataPath '*.jpg']);
% for i = 1:length(data)
%     i
%     im=rgb2gray(imread(strcat(dataPath,num2str(i),'.jpg')));
%     aviObj = addframe(aviObj,uint8(im));
% end
% 
% aviObj=close(aviObj);
