clear all;
close all;
clc;
%%-------------------------Note------------------------------%%
%File:SDT detection software
%Paper: Effective Small Dim Target Detection by Local Connectedness Constrains 
%Author: Keren Fu
%%----------------------Parameter setting------------------------%%
para.Outer_R=6;  %Outter window radius
para.Entire_R=para.Outer_R+2;%Marginal window radius
para.Inner_R=0;  %Inner window radius
para.TO=40;      %overshot threshold 
para.ST=0.5;     %confidence ratio threshold
para.Polar_R=round(para.Outer_R/2);%local range for speedup;
para.Enable_Speedup=1; %1/0
%%----------------------input path------------------------------%%
input_path =  'test_img\';    
output_path = './result/';
abc_filelist = dir([input_path '/*.bmp']);
len = length(abc_filelist);

 %% begin for each image
for Pix=1:len 
string_file=abc_filelist(Pix).name;
disp(['processing the ' num2str(Pix),'th input: ',string_file]);
Im = imread([input_path string_file]);
if size(Im,3)==3
   Im= double(rgb2gray(Im))/255;
else
   Im= double(Im)/255; 
end

%%------------------------SDT detection----------------------------%%

[info_record]=SDT_Detection(Im,para);

%%------------------------draw-rectangle----------------------------%%
Target_On_Im=repmat(Im,[1,1,3]);% draw target on image 
if isempty(info_record)~=1
    target_number=length(info_record(:,1));
    for i=1:1:target_number
        spy=info_record(i,1);
        spx=info_record(i,2);
        actual_size=info_record(i,3);
    
        Target_On_Im(spy-para.Outer_R:spy+para.Outer_R,spx-para.Outer_R,:)=repmat(reshape([1,0,0],[1 1 3]),[2*(para.Outer_R)+1,1]);
        Target_On_Im(spy-para.Outer_R:spy+para.Outer_R,spx+para.Outer_R,:)=repmat(reshape([1,0,0],[1 1 3]),[2*para.Outer_R+1,1]);
        Target_On_Im(spy-para.Outer_R,spx-para.Outer_R:spx+para.Outer_R,:)=repmat(reshape([1,0,0],[1 1 3]),[1,2*para.Outer_R+1]);
        Target_On_Im(spy+para.Outer_R,spx-para.Outer_R:spx+para.Outer_R,:)=repmat(reshape([1,0,0],[1 1 3]),[1,2*para.Outer_R+1]);

        Target_On_Im(spy-actual_size:spy+actual_size,spx-actual_size,:)=repmat(reshape([0,1,0],[1 1 3]),[2*actual_size+1,1]);
        Target_On_Im(spy-actual_size:spy+actual_size,spx+actual_size,:)=repmat(reshape([0,1,0],[1 1 3]),[2*actual_size+1,1]);
        Target_On_Im(spy-actual_size,spx-actual_size:spx+actual_size,:)=repmat(reshape([0,1,0],[1 1 3]),[1,2*actual_size+1]);
        Target_On_Im(spy+actual_size,spx-actual_size:spx+actual_size,:)=repmat(reshape([0,1,0],[1 1 3]),[1,2*actual_size+1]);
    end
end
%%------------------------show-score----------------------------%%
figure(1);
imshow([Target_On_Im,repmat(Im,[1,1,3])],[0 1]);
if isempty(info_record)~=1
    for i=1:1:target_number
        spy=info_record(i,1);
        spx=info_record(i,2);
        score=info_record(i,4);
        text(spx,spy-para.Entire_R, num2str(score));
    end
end

saveas(gcf,strcat(output_path,string_file(1:end-4),'_score.png'));%save image with scores on it
end





