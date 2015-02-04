videoPath='babyVideo\M2U00734.MPG';
resultPath='babyVideo\temp\';
showVideo=false;
saveFrame=true;

videoFReader = vision.VideoFileReader(videoPath);
videoPlayer = vision.VideoPlayer;   %uncomment it if you want to show the video

idx=1;
while ~isDone(videoFReader)
    fprintf('Extract frame: %d.\n', idx); 
    videoFrame = step(videoFReader);
    path=strcat(resultPath,num2str(idx),'.jpg');
    imGray=rgb2gray(videoFrame);  %convert to gray image
    if saveFrame==true
        imwrite(imGray,path);
    end
    if showVideo==true
        step(videoPlayer, videoFrame);
    end
   
    idx=idx+1;
end

if showVideo==true
    release(videoPlayer);
end
release(videoFReader);