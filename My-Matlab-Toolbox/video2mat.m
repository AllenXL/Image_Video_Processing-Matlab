function videoClip= video2mat(videoPath)

mov= VideoReader(videoPath);
videoClip=zeros(mov.Height,mov.Width,mov.numberofframe);
for i=1:mov.numberofframe
    videoClip(:,:,i)=rgb2gray(read(mov,i));
end

end

