% Surendra 算法
% Surendra 
% title : Detection and Classification of Vehicles
close all 
clear all
clc
path='F:\VideoDataset\FightingDataset\frm\M2U01418\';
source=dir([path  '*.tif']);

nStar = 3;
nStep = 20;
nNUM = 436;
x1 = 1;
x2 = 320;
y1 = 1;
y2 = 240;

% 视频序列的第一帧
Background = double(imread(strcat(path,source(1).name)));
Background = Background(y1:y2,x1:x2);
% 输出背景
figure(1),imshow( uint8( Background ));
% 更新过程
for k=2:length(source)-2
    % 当前帧
    CurrentImage = double( imread(strcat(path,source(k).name)));
    CurrentImage = CurrentImage(y1:y2,x1:x2);
    % 前一帧
    FormerImage = double( imread(strcat(path,source(k-1).name)));
    FormerImage = FormerImage(y1:y2,x1:x2);
    % 帧间差分
    ID = ( abs( CurrentImage - FormerImage ));
    %  选择阈值
    x = 0:255;
    n = hist( ID(:),x ) ;
    C = max (n);
    T = min( find ( n<= C./10 ));
    BW = ( sign ( ID-T ) + sign ( abs( ID - T )) )./2;
    
    % 更新背景
    alpha = 0.1;
    CurrentBack = Background.*BW + ( alpha.* CurrentImage + ( 1-alpha ).* Background ).*( 1 -BW );
    Background = CurrentBack;
    %imshow( uint8 ( Background ) );
end
% 输出更新后的背景
figure(2),imshow( uint8 ( CurrentBack ) );

% 视频序列的最后一帧
Image = double(imread(strcat(path,source(437).name)));
Image = Image(y1:y2,x1:x2);
figure(3),imshow( uint8 ( Image ));

    
    
    




