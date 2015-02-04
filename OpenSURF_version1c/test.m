% Load images
I1=rgb2gray(imread('babyArm2.jpg'));

% Get the Key Points
%Options.upright=true;
Options.init_sample=5;
Options.tresh=0.0008;
Options.octaves=2;
Ipts1=OpenSurf(I1,Options);
imshow(I1,[]);
hold on;
for i=1:length(Ipts1)
    plot(round(Ipts1(i).x),round(Ipts1(i).y),'*r');
end