function [] = drawExtrema( img, extrema, range )
%DRAWEXTREMA Summary of this function goes here
%   Detailed explanation goes here
figure;
imshow(img, range);
[x,y] = size(img);

for j = 1:y,
    for i = 1:x, %i<250 & & img(i,j)>20
        if (extrema(i,j) == -1 && img(i,j)<45)
            disp(strcat('i=',num2str(i),',j=',num2str(j),',gray=',num2str(img(i,j))));
            line('xdata',[j-1 j+1], 'ydata',[i-1 i-1], 'color', 'red');
            line('xdata',[j-1 j+1], 'ydata',[i+1 i+1], 'color', 'red');
            line('xdata',[j-1 j-1], 'ydata',[i-1 i+1], 'color', 'red');
            line('xdata',[j+1 j+1], 'ydata',[i-1 i+1], 'color', 'red');
        end
%         if (extrema(i,j) == 1&&img(i,j)<120 && img(i,j)>115),
%             line('xdata',[j-1 j+1], 'ydata',[i-1 i-1], 'color', 'green');
%             line('xdata',[j-1 j+1], 'ydata',[i+1 i+1], 'color', 'green');
%             line('xdata',[j-1 j-1], 'ydata',[i-1 i+1], 'color', 'green');
%             line('xdata',[j+1 j+1], 'ydata',[i-1 i+1], 'color', 'green');
%         end
        
    end
end


end

