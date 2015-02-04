%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROJECT:
%     KLT Tracker
%
% BY:
%     Parthipan Siva
%     Assignment for SD 770-7: Topics in Particle Filtering
%     Systems Design Engineering
%     University of Waterloo
%
% DATE/Version:
%     Jan. 2007 - V 1.0
%
% Description:  kltTrackSIMPLE.m
%               Given the output of the KLT tracker code (feature list of
%               tracked and new points) this function will track an object
%               within the specified region using only the initial KLT
%               features detected by the KLT tracker code. No processing
%               is done within this code, it mearly displays the results of
%               the KLT tracker code. The center of the object is assumed
%               as the centroid of all KLT features.
%
% References:
%     http://www.ces.clemson.edu/~stb/klt/
%
% Project file list: 
%     drawEllipse.m
%     InsidePolygon.m
%     kltTrack.m
%     kltTrackSIMPLE.m
%     readKLTFeatureList.m
%     Example1.m
%     Example2.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          dir - the directory location where the KLT features are located
%          dir2 - the directory where the pgm image for each frame is
%                 located
%          fileStart1 - the start of a file name (not including the frame
%                       number) it is assumed that KLT features and image
%                       files have the same file nume but with extensions
%                       .txt and .pgm
%          h - the spread in row and col directions of the ellipse 
%              sarounding the object (on the first frame)
%          y - the center location of the object on the first frame
%          startFrame - the start frame number
%          endFrame - the frame number at which to end tracking
%          TOL - the tollerance on the KLT featurs to use
%          angle - the orientation of the ellipse sarrounding the object
%          SHOW_FIG - (optional) 1 to display figures (if movieFileName 
%                     specified regardless of this state figure is shown)
%          movieFileName - (optional) if a movie is needed specify file
%                          name with .avi extension
%          framesPerSec - (optional) the fps for the avi, if not specified 
%                         set to 5
%
% OUTPUTS:
%          frameInfo - struct containing the info for each frame
%                           INDEX_OF_KEY_PTS - the key points used for
%                                              tracking
%                           y - the center location of object ellipse
%                           h - the row col spread of object ellipse
%                           ellipse - cordinates along the ellipse boundar
%                                   used for ploting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [frameInfo]  = kltTrackSIMPLE(dir, dir2, fileStart1, h, y, startFrame, ...
    endFrame, TOL, angle, SHOW_FIG, movieFileName, framesPerSec)

if nargin < 9
    disp('Warning not enough parameters');
    pause;
elseif nargin == 9
    SHOW_FIG = 0;
    makeMovie = 0;
elseif nargin == 10
    makeMovie = 0;
elseif nargin == 11
    framesPerSec = 5;
    makeMovie = 1;
elseif nargin == 12
    makeMovie = 1;
end

fileEnd1 = '.ppm';
fileEnd2 = '.txt';
fileEnd3 = '.pgm';

% TOL has to be 0 or greater
if (TOL < 0)
    TOL = 0;
end

if (SHOW_FIG == 1 || makeMovie == 1)
    fig = figure;
end
if (makeMovie == 1)
    set(fig,'DoubleBuffer','on');
    mov = avifile(movieFileName,'compression','none');
end

INDEX_OF_KEY_PTS = [];

% load the first frame KLT features
PointList = readKLTFeatureList([dir fileStart1 num2str(startFrame) fileEnd2]);

% get the ellipse sarrounding the object of interest
ellipse = drawEllipse(y,h/2,angle);

% find all KLT features inside the ellipse
polygon = [ellipse(2,:)' ellipse(1,:)'];
for j = 1:size(PointList,1)
    if (PointList(j,4)>TOL)
        pt = [PointList(j,2) PointList(j,3)];
        [Inside] = InsidePolygon(polygon, pt);
        if (Inside == 1)
            INDEX_OF_KEY_PTS(end+1) = j;
        end
    end
end

% show/add to movie the first frame
if (SHOW_FIG == 1 || makeMovie == 1)
    % read the first image
    I = imread([dir2 fileStart1 num2str(startFrame) fileEnd3]);
    imshow(I); hold on;
    plot(PointList(INDEX_OF_KEY_PTS,2),PointList(INDEX_OF_KEY_PTS,3),'gx');
    plot(ellipse(2,:),ellipse(1,:));
    if (makeMovie == 0)
        pause(0.1);
    else
         F = getframe(gca);
         mov = addframe(mov,F);
    end
end

frameInfoIndex = 1;
frameInfo(frameInfoIndex).INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS;
frameInfo(frameInfoIndex).y = y;
frameInfo(frameInfoIndex).h = h;
frameInfo(frameInfoIndex).ellipse = ellipse;
frameInfoIndex = frameInfoIndex + 1;

for i = startFrame+1:endFrame
    
    % load the KLT features for the current frame
    PointList = readKLTFeatureList([dir fileStart1 num2str(i) fileEnd2]);
    
    % Get rid of points not sucessfully tracked
    j = 1;
    while j<=numel(INDEX_OF_KEY_PTS)
        if (PointList(INDEX_OF_KEY_PTS(j),4)~=0)
            if j == 1
                INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS(2:end);
            elseif j == numel(INDEX_OF_KEY_PTS)
                INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS(1:end-1);
            else
                INDEX_OF_KEY_PTS = [INDEX_OF_KEY_PTS(1:j-1) INDEX_OF_KEY_PTS(j+1:end)];
            end
        else
            j = j + 1;
        end
    end

    % get the current center of the ellipse as the centroid of all the KLT
    % features associated with the object in the current frame.
    currCenter = [sum(PointList(INDEX_OF_KEY_PTS,2))/numel(INDEX_OF_KEY_PTS) ...
        sum(PointList(INDEX_OF_KEY_PTS,3))/numel(INDEX_OF_KEY_PTS)];
    
    % get the new ellipse boundary coordinates
    ellipse = drawEllipse([currCenter(2) currCenter(1)],h/2,angle);
    
    % show all points that were successfully tracked
    if (SHOW_FIG == 1 || makeMovie == 1)
    
        I = imread([dir2 fileStart1 num2str(i) fileEnd3]);
        imshow(I); hold on;
    
        plot(PointList(INDEX_OF_KEY_PTS,2),PointList(INDEX_OF_KEY_PTS,3),'g.');
        
        % Plot the ellipse
        plot(ellipse(2,:),ellipse(1,:));
        
        % Plot the center of the ellipse
        plot(currCenter(1),currCenter(2),'b.');
        
        if (makeMovie == 0)
            pause(0.1);
        else
            F = getframe(gca);
            mov = addframe(mov,F);
        end
    end
    
    frameInfo(frameInfoIndex).INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS;
    frameInfo(frameInfoIndex).y = [currCenter(2) currCenter(1)];
    frameInfo(frameInfoIndex).h = h;
    frameInfo(frameInfoIndex).ellipse = ellipse;
    frameInfoIndex = frameInfoIndex + 1;
    
    if (numel(INDEX_OF_KEY_PTS) == 0)
        break;
    end
end

if (makeMovie == 1)
    mov = close(mov);
end