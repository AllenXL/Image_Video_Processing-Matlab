function [info_record]=SDT_Detection(Im,para)
Outer_R=para.Outer_R;  %Outter window radius
Entire_R=para.Entire_R;%Marginal window radius
Inner_R=para.Inner_R;  %Inner window radius
TO=para.TO;      %overshot threshold 
ST=para.ST;     %confidence ratio threshold
Polar_R=para.Polar_R;%local range for speedup;
Enable_Speedup=para.Enable_Speedup; %1/0

%%----------------------Pre-processing----------------------------%%
Im=1-(Im-min(Im(:)))/(max(Im(:))-min(Im(:)));
[ImSizeY,ImSizeX] = size(Im);
%%----------------------Initialization----------------------------%%
DecisionMap = zeros(ImSizeY,ImSizeX); 
SizeMap = zeros(ImSizeY,ImSizeX); 
ScoreMap = zeros(ImSizeY,ImSizeX); 
 %% for each sliding window
for i = Entire_R+1 : ImSizeY-Entire_R
    for j = Entire_R+1 : ImSizeX-Entire_R
        
          Sub_img=Im(i-Entire_R:i+Entire_R,j-Entire_R:j+Entire_R);%entire patch with marginal window size
          
          LocalDifference=Sub_img(1+Entire_R-Polar_R:1+Entire_R+Polar_R,1+Entire_R-Polar_R:1+Entire_R+Polar_R)-Sub_img(1+Entire_R,1+Entire_R);%for speedup
          
          Outter_Patch=Im(i-Outer_R:i+Outer_R,j-Outer_R:j+Outer_R);%for background estimation
          
          Marginal_Average=(sum(Sub_img(:))-sum(Outter_Patch(:)))/(4*(Entire_R-Outer_R)*(Entire_R+Outer_R+1));%background estimation
          
%           T=min([Im(i,j)-TO/255,(Im(i,j)+Marginal_Average)/2]);%local threshold
         T=Im(i,j)-TO/255;
          B=Sub_img>=T;%binarizing threshold
          
          if (~Enable_Speedup)||max(LocalDifference(:))==0%whether need speedup
              
                  Label=bwlabel(B,8);%direct connectivity found (instead of region growing)
                  
                  center_label=Label(1+Entire_R,1+Entire_R);%find central label
                  
                  Label=(Label==center_label);%find region containing central label
                  
                %% Condition (i)
                  Label_Inner=Label(1+Entire_R-Inner_R:1+Entire_R+Inner_R,1+Entire_R-Inner_R:1+Entire_R+Inner_R);%内窗口

                  if sum(Label_Inner(:))==(2*Inner_R+1)^2
                      Condition_Inner=1;
                  else
                      Condition_Inner=0;
                  end
                %% Condition (ii)
                  Label_Outter=Label;
                  Label_Outter(1+Entire_R-Outer_R:1+Entire_R+Outer_R,1+Entire_R-Outer_R:1+Entire_R+Outer_R)=0;%外窗口
                  if max(Label_Outter(:))==0
                      Condition_Outer=1;
                  else
                      Condition_Outer=0;
                  end
                  
                %% Condition (i) & (ii)
                  if Condition_Inner==1&&Condition_Outer==1
                      
                      DecisionMap(i ,j)=1;
                   %% Shrink outter window and dilate inner window
                      for Actual_Outer_R=Outer_R:-1:0
                          Label_Outter=Label;
                          Label_Outter(1+Entire_R-Actual_Outer_R:1+Entire_R+Actual_Outer_R,1+Entire_R-Actual_Outer_R:1+Entire_R+Actual_Outer_R)=0;
                          if max(Label_Outter(:))==1
                              break
                          end 
                      end
                    %% Obtain actual size
                      SizeMap(i,j)=Actual_Outer_R+1;
                    %% Obtain contrast score
                      ScoreMap(i,j)=Im(i,j)-Marginal_Average;
                  else
                      DecisionMap(i ,j)=0;
                      ScoreMap(i,j)=0;
                  end
          else
              DecisionMap(i,j)=0;
              ScoreMap(i,j)=0;
          end
    end
end

%%------------------------Post-processing----------------------------%%
label_map=bwlabel(DecisionMap);%8-neighbor connectivity region
Target_number=max(label_map(:));% region number
ScoreMap=ScoreMap/max(ScoreMap(:));%normalize to have maximum 1

info_record=[];
if Target_number~=0
    for i=1:1:Target_number
        index=find(label_map==i);
        actual_size=min(SizeMap(index));%actual size
        actual_score=max(ScoreMap(index));        %acutal score
        if actual_score>ST %record target with score>ST
            point_number=length(index);
            spx=0;
            spy=0;
            for j=1:1:point_number
                point_index=index(j);
                px=ceil(point_index/ImSizeY);
                py=point_index-(px-1)*ImSizeY;
                spx=spx+px;
                spy=spy+py;
            end
            spy=round(spy/point_number);
            spx=round(spx/point_number);

            info_record=[info_record;spy,spx,actual_size,actual_score];
        end
    end
end

end