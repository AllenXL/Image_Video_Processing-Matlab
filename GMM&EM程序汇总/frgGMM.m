clear all
% source = aviread('C:\Video\Source\traffic\san_fran_traffic_30sec_QVGA');
source = VideoReader('G:\\2.avi');     %������Ƶ�ļ�
frameQYT=source.NumberOfFrames;
% -----------------------  frame size variables -----------------------

fr = read(source,1);           % ��ȡ��һ֡��Ϊ����
fr_bw = rgb2gray(fr);          % ������ת��Ϊ�Ҷ�ͼ��
fr_size = size(fr);             %ȡ֡��С
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);
bg_bw = zeros(height, width);
% --------------------- mog variables -----------------------------------
C =3;                                  % ��ɻ�ϸ�˹�ĵ���˹��Ŀ (һ��3-5)
M = 0;                                  % ��ɱ�������Ŀ
D = 2.5;    %2.5                            % ��ֵ��һ��2.5����׼�
alpha = 0.01;                           % learning rate ѧϰ�ʾ��������ٶ�(between 0 and 1) (from paper 0.01)
thresh = 0.5;                          % foreground threshold ǰ����ֵ(0.25 or 0.75 in paper)
sd_init = 2;                            % initial standard deviation ��ʼ����׼��(for new components) var = 36 in paper
w = zeros(height,width,C);              % initialize weights array ��ʼ��Ȩֵ����
mean = zeros(height,width,C);           % pixel means ���ؾ�ֵ
sd = zeros(height,width,C);             % pixel standard deviations ���ر�׼��
u_diff = zeros(height,width,C);         % difference of each pixel from mean ���ֵ�Ĳ�
p = alpha/(1/C);                        % initial p variable ����ѧϰ��(used to update mean and sd)
rank = zeros(1,C);                      % rank of components (w/sd)

% ------initialize component means and weights ��ʼ����ֵ��Ȩֵ----------
pixel_depth = 8;                        % 8-bit resolution �������Ϊ8λ
pixel_range = 2^pixel_depth -1;         % pixel range ���ط�Χ2��7�η�0��255��# of possible values)
for i=1:height
    for j=1:width
        for k=1:C
            
            mean(i,j,k) = rand*pixel_range;     % means random (0-255֮��������)
            w(i,j,k) = 1/C;                     % weights uniformly dist
            sd(i,j,k) = sd_init;                % initialize to sd_init
            
        end
    end
end
%----- process frames -����֡--������ȥ�ڰ�֡ 
for n=80:frameQYT
      %n = 8;
    fr = read(source,n);       % read in frame ��ȡ֡
    fr_bw = rgb2gray(fr);       % convert frame to grayscale ת��Ϊ�Ҷ�ͼ��
    
    % calculate difference of pixel values from mean �������ز�ֵ
    for m=1:C
        u_diff(:,:,m) = abs(double(fr_bw) - double(mean(:,:,m)));
    end
     
    % update gaussian components for each pixel ����ÿ�����صı���ģ��
    for i=1:height
        for j=1:width
            
            match = 0;
            for k=1:C                       
                if (abs(u_diff(i,j,k)) <= D*sd(i,j,k))       % pixel matches component����ƥ����ģ��
                    
                    match = 1;                          % variable to signal component match ����ƥ��Ǻ�
                    
                    % update weights, mean, sd, p  ����Ȩֵ����ֵ����׼��Ͳ���ѧϰ��
                    w(i,j,k) = (1-alpha)*w(i,j,k) + alpha;
                    p = alpha/w(i,j,k);                  
                    mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(fr_bw(i,j));
                    sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
                else                                    % pixel doesn't match component ����ģ���ж�û��ƥ���
                    w(i,j,k) = (1-alpha)*w(i,j,k);      % weight slighly decreases Ȩֵ��С
                    
                end
            end
            
                  
            bg_bw(i,j)=0;
            for k=1:C
                bg_bw(i,j) = bg_bw(i,j)+ mean(i,j,k)*w(i,j,k);  %���±���
                if(bg_bw(i,j)>thresh)
                   k=k-1;
                   M=k;
                end%????   ���������⣬����Ȩֵ�ʹ�����ֵʱ��������ģ����ĿMȡk-1,
            end
            
            
            % if no components match, create new component ���û��ƥ���ģ���򴴽���ģ��
            if (match == 0)
                [min_w, min_w_index] = min(w(i,j,:));  
                mean(i,j,min_w_index) = double(fr_bw(i,j));
                sd(i,j,min_w_index) = sd_init;
            end
            rank = w(i,j,:)./sd(i,j,:);             % calculate component rank ����ģ�����ȼ�
            rank_ind = [1:1:C];
            
            
            % calculate foreground ����ǰ��
            
             match
             k
             M
            while ((match == 0)&&(k>M))%?????       ��������ǰ������ĸ�˹ģ��Ӧ����C-M,��������k>M           
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

    
    figure(1),subplot(3,1,1),imshow(fr)    %��ʾ����ͼ��
    subplot(3,1,2),imshow(uint8(bg_bw))    %��ʾ����ͼ��
    subplot(3,1,3),imshow(uint8(fg))     %��ʾǰ��ͼ��
    title(num2str(n));
end