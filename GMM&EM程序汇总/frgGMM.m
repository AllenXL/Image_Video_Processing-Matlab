clear all
% source = aviread('C:\Video\Source\traffic\san_fran_traffic_30sec_QVGA');
source = VideoReader('G:\\2.avi');     %读入视频文件
frameQYT=source.NumberOfFrames;
% -----------------------  frame size variables -----------------------

fr = read(source,1);           % 读取第一帧作为背景
fr_bw = rgb2gray(fr);          % 将背景转换为灰度图像
fr_size = size(fr);             %取帧大小
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);
bg_bw = zeros(height, width);
% --------------------- mog variables -----------------------------------
C =3;                                  % 组成混合高斯的单高斯数目 (一般3-5)
M = 0;                                  % 组成背景的数目
D = 2.5;    %2.5                            % 阈值（一般2.5个标准差）
alpha = 0.01;                           % learning rate 学习率决定更新速度(between 0 and 1) (from paper 0.01)
thresh = 0.5;                          % foreground threshold 前景阈值(0.25 or 0.75 in paper)
sd_init = 2;                            % initial standard deviation 初始化标准差(for new components) var = 36 in paper
w = zeros(height,width,C);              % initialize weights array 初始化权值数组
mean = zeros(height,width,C);           % pixel means 像素均值
sd = zeros(height,width,C);             % pixel standard deviations 像素标准差
u_diff = zeros(height,width,C);         % difference of each pixel from mean 与均值的差
p = alpha/(1/C);                        % initial p variable 参数学习率(used to update mean and sd)
rank = zeros(1,C);                      % rank of components (w/sd)

% ------initialize component means and weights 初始化均值和权值----------
pixel_depth = 8;                        % 8-bit resolution 像素深度为8位
pixel_range = 2^pixel_depth -1;         % pixel range 像素范围2的7次方0—255（# of possible values)
for i=1:height
    for j=1:width
        for k=1:C
            
            mean(i,j,k) = rand*pixel_range;     % means random (0-255之间的随机数)
            w(i,j,k) = 1/C;                     % weights uniformly dist
            sd(i,j,k) = sd_init;                % initialize to sd_init
            
        end
    end
end
%----- process frames -处理帧--，这里去第八帧 
for n=80:frameQYT
      %n = 8;
    fr = read(source,n);       % read in frame 读取帧
    fr_bw = rgb2gray(fr);       % convert frame to grayscale 转换为灰度图像
    
    % calculate difference of pixel values from mean 计算像素差值
    for m=1:C
        u_diff(:,:,m) = abs(double(fr_bw) - double(mean(:,:,m)));
    end
     
    % update gaussian components for each pixel 更新每个像素的背景模型
    for i=1:height
        for j=1:width
            
            match = 0;
            for k=1:C                       
                if (abs(u_diff(i,j,k)) <= D*sd(i,j,k))       % pixel matches component像素匹配了模型
                    
                    match = 1;                          % variable to signal component match 设置匹配记号
                    
                    % update weights, mean, sd, p  更新权值，均值，标准差和参数学习率
                    w(i,j,k) = (1-alpha)*w(i,j,k) + alpha;
                    p = alpha/w(i,j,k);                  
                    mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(fr_bw(i,j));
                    sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
                else                                    % pixel doesn't match component 几个模型中都没有匹配的
                    w(i,j,k) = (1-alpha)*w(i,j,k);      % weight slighly decreases 权值减小
                    
                end
            end
            
                  
            bg_bw(i,j)=0;
            for k=1:C
                bg_bw(i,j) = bg_bw(i,j)+ mean(i,j,k)*w(i,j,k);  %更新背景
                if(bg_bw(i,j)>thresh)
                   k=k-1;
                   M=k;
                end%????   这里有问题，背景权值和大于阈值时，背景建模的数目M取k-1,
            end
            
            
            % if no components match, create new component 如果没有匹配的模型则创建新模型
            if (match == 0)
                [min_w, min_w_index] = min(w(i,j,:));  
                mean(i,j,min_w_index) = double(fr_bw(i,j));
                sd(i,j,min_w_index) = sd_init;
            end
            rank = w(i,j,:)./sd(i,j,:);             % calculate component rank 计算模型优先级
            rank_ind = [1:1:C];
            
            
            % calculate foreground 计算前景
            
             match
             k
             M
            while ((match == 0)&&(k>M))%?????       这里用于前景计算的高斯模型应该是C-M,所以这里k>M           
                    if (abs(u_diff(i,j,rank_ind(k))) <= D*sd(i,j,rank_ind(k)))
                        fg(i,j) = 0;     %black = 0          
                    else
                        fg(i,j) = fr_bw(i,j);
                    end
         
                k = k+1;
                if(k==5)
                   k=k-1;
                   break
                end
            end
        end
    end

    
    figure(1),subplot(3,1,1),imshow(fr)    %显示输入图像
    subplot(3,1,2),imshow(uint8(bg_bw))    %显示背景图像
    subplot(3,1,3),imshow(uint8(fg))     %显示前景图像
    title(num2str(n));
end