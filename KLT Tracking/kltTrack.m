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
% Description:  kltTrack.m
%               Given the output of the KLT tracker code (feature list of
%               tracked and new points) this function will track an object
%               with the use of replaced features.
%               Note it is assumed that the KLT features were started at 
%               startFrame that is that all features in the KLT feature 
%               list file for startFrame has a value > 0.
%               Note ellipse as defined by h, y and angle are assumed to be
%               choosen such that all KLT features withing the ellipse on 
%               the start frame belongs to the object of interest.
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
%          TIME_WINDOW - the duration in frames during which the KLT
%                        feature points must have moved
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
%                           INDEX_OF_KEY_PTS_POT - the key points that were
%                                  used as replacement/addition for orignal
%                                  feature points
%                           y - the center location of object ellipse
%                           h - the row col spread of object ellipse
%                           ellipse - cordinates along the ellipse boundar
%                                   used for ploting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [frameInfo]  = kltTrack(dir, dir2, fileStart1, h, y, startFrame, ...
    endFrame, TOL, angle, TIME_WINDOW, SHOW_FIG, movieFileName, framesPerSec)

if nargin < 10
    disp('Warning not enough parameters');
    pause;
elseif nargin == 10
    SHOW_FIG = 0;
    makeMovie = 0;
elseif nargin == 11
    makeMovie = 0;
elseif nargin == 12
    framesPerSec = 5;
    makeMovie = 1;
elseif nargin == 13
    makeMovie = 1;
end

fileEnd1 = '.ppm';
fileEnd2 = '.txt';
fileEnd3 = '.pgm';

frameInfoIndex = 1;

% initialise arrays used to keep track of key points
INDEX_OF_KEY_PTS = [];     % these are the set of points on the object for sure
INDEX_OF_KEY_PTS_POT = []; % these are the set of points that can potentially be on the object
% We will keep adding potential points to INDEX_OF_KEY_PTS based on its
% behaviour. Note when a point is added to INDEX_OF_KEY_PTS from
% INDEX_OF_KEY_PTS_POT it is not deleted from INDEX_OF_KEY_PTS_POT. It is
% kept as part of INDEX_OF_KEY_PTS_POT until the point stops moving for
% TIME_WINDOW number of frames, at which point it is deleted from
% INDEX_OF_KEY_PTS_POT and INDEX_OF_KEY_PTS. This is done to remove any
% KLT points that appears behind the object motion. In this case the KLT
% feature will dissapear and then reapear as the object passes over it.
% Once the object passes over it, the KLT point will be detected as a new
% feature but we don't want this to be added to the object being tracked.

% read the KLT feature points on the first frame
PointList = readKLTFeatureList([dir fileStart1 num2str(startFrame) fileEnd2]);

% get coordinates of an ellipse sarrounding the inital location of the
% object to track
ellipse = drawEllipse(y,h/2,angle);

% Find all KLT feature points within the ellipse sarounding the object
polygon = [ellipse(2,:)' ellipse(1,:)'];
for j = 1:size(PointList,1)
    if (PointList(j,4)>TOL)
        pt = [PointList(j,2) PointList(j,3)];
        
        % if the KLT feature is inside the ellipse assume it is a featur to
        % track.
        [Inside] = InsidePolygon(polygon, pt);
        if (Inside == 1)
            INDEX_OF_KEY_PTS(end+1) = j;
        end
    end
end

if (SHOW_FIG == 1 || makeMovie == 1)
    fig = figure;
end
if (makeMovie == 1)
    set(fig,'DoubleBuffer','on');
    mov = avifile(movieFileName,'compression','none');
end

if (SHOW_FIG == 1 || makeMovie == 1)
    % read the first image
    I = imread([dir2 fileStart1 num2str(startFrame) fileEnd3]);
    imshow(I); hold on;
    plot(PointList(INDEX_OF_KEY_PTS,2),PointList(INDEX_OF_KEY_PTS,3),'x');
    plot(ellipse(2,:),ellipse(1,:));
    if (makeMovie == 0)
        pause(0.1);
    else
         F = getframe(gca);
         mov = addframe(mov,F);
    end
end

frameInfo(frameInfoIndex).INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS;
frameInfo(frameInfoIndex).INDEX_OF_KEY_PTS_POT = INDEX_OF_KEY_PTS_POT;
frameInfo(frameInfoIndex).y = y;
frameInfo(frameInfoIndex).h = h;
frameInfo(frameInfoIndex).ellipse = ellipse;
frameInfoIndex = frameInfoIndex + 1;

% loop through remaining figures and track the object defined in the
% ellipse.
distTimeIndex = 1;
for i = startFrame+1:endFrame
    
    % save the previous list
    PointListPrev = PointList;

    % Read the KLT features for current frame
    PointList = readKLTFeatureList([dir fileStart1 num2str(i) fileEnd2]);

    % find the distance travelled between last frame and current frame.
    % Keep the history for TIME_WINDOW number of frames.
    if (distTimeIndex > TIME_WINDOW)
        PastDist = PastDist(:,2:end);
        PastDist(:,end+1) = sqrt((PointList(:,2)-PointListPrev(:,2)).^2 + (PointList(:,3)-PointListPrev(:,3)).^2);
    else
        PastDist(:,distTimeIndex) = sqrt((PointList(:,2)-PointListPrev(:,2)).^2 + (PointList(:,3)-PointListPrev(:,3)).^2);
    end
    distTimeIndex = distTimeIndex + 1;

    % if the KLT feature is new in the current frame, set dist travelled in
    % the previous frames to a large number.
    locs = find(PointList(:,4)>0);
    PastDist(locs,:) = 99;

    % get rid of points that were not successfully traced to current frame.
    % These features are lost.
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
    
    % The object size and orientation is not changed. Only it's location is
    % changed. That is we are assuming only translational motion.
    
%     % get the previous center of the ellipse as the centroid of all the KLT
%     % features associated with the object in the previous frame.
%     prevCenter = [sum(PointListPrev(INDEX_OF_KEY_PTS,2))/numel(INDEX_OF_KEY_PTS) ...
%         sum(PointListPrev(INDEX_OF_KEY_PTS,3))/numel(INDEX_OF_KEY_PTS)];

    % get the current center of the ellipse as the centroid of all the KLT
    % features associated with the object in the current frame.
    currCenter = [sum(PointList(INDEX_OF_KEY_PTS,2))/numel(INDEX_OF_KEY_PTS) ...
        sum(PointList(INDEX_OF_KEY_PTS,3))/numel(INDEX_OF_KEY_PTS)];

    % get the new ellipse boundary coordinates
    ellipse = drawEllipse([currCenter(2) currCenter(1)],h/2,angle);

    % Elliminate all key points not inside the ellipse in the current
    % location. This needs to be removed if we assume the scale of the
    % object is changing.
    polygon = [ellipse(2,:)' ellipse(1,:)'];
    j = 1;
    while j<=numel(INDEX_OF_KEY_PTS)
        pt = [PointList(INDEX_OF_KEY_PTS(j),2) PointList(INDEX_OF_KEY_PTS(j),3)];
        [Inside] = InsidePolygon(polygon, pt);
        if (Inside==0)
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

    % Loop through the potential key points and remove those potential
    % keypoint that were not tracked to current frame
    j = 1;
    while j<=numel(INDEX_OF_KEY_PTS_POT)
        if (PointList(INDEX_OF_KEY_PTS_POT(j),4)~=0)
            
            % when removing the points ensure it is also removed from
            % INDEX_OF_KEY_PTS. ***** NOT SURE IF THIS IS NEEDED, THIS
            % SHOULD BE REDUNDENT CODE *****
            k = 1;
            while (k <= numel(INDEX_OF_KEY_PTS))
                if (INDEX_OF_KEY_PTS(k) == INDEX_OF_KEY_PTS_POT(j))
                    if k == 1
                        INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS(2:end);
                    elseif k == numel(INDEX_OF_KEY_PTS)
                        INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS(1:end-1);
                    else
                        INDEX_OF_KEY_PTS = [INDEX_OF_KEY_PTS(1:k-1) INDEX_OF_KEY_PTS(k+1:end)];
                    end
                    k = numel(INDEX_OF_KEY_PTS) + 1;
                end
                k = k + 1;
            end
            
            if j == 1
                INDEX_OF_KEY_PTS_POT = INDEX_OF_KEY_PTS_POT(2:end);
            elseif j == numel(INDEX_OF_KEY_PTS_POT)
                INDEX_OF_KEY_PTS_POT = INDEX_OF_KEY_PTS_POT(1:end-1);
            else
                INDEX_OF_KEY_PTS_POT = [INDEX_OF_KEY_PTS_POT(1:j-1) INDEX_OF_KEY_PTS_POT(j+1:end)];
            end
        else
            j = j + 1;
        end
    end

    % check for new KLT feature points that lie inside the ellipse. If such
    % a point exist inside the ellipse add it to both INDEX_OF_KEY_PTS_POT
    % and INDEX_OF_KEY_PTS
    for j = 1:size(PointList,1)
        if (PointList(j,4) > TOL)
            pt = [PointList(j,2) PointList(j,3)];
            [Inside] = InsidePolygon(polygon, pt);
            if (Inside == 1)
                INDEX_OF_KEY_PTS_POT(end+1) = j;

                % add to INDEX_OF_KEY_PTS

                INDEX_OF_KEY_PTS(end+1) = j;
            end
        end
    end
    
    if (SHOW_FIG == 1 || makeMovie == 1)
        % get current frame
        I = imread([dir2 fileStart1 num2str(i) fileEnd3]);
        imshow(I); hold on;

        % Plot all new feature points
        tempLocs = find(PointList(:,4)>TOL);
        plot(PointList(tempLocs,2),PointList(tempLocs,3),'.');

%         tempLocs = find(PointList(1:130,4)==0);
%         plot(PointList(tempLocs,2),PointList(tempLocs,3),'r.');

        % Plot all KLT features associated to object
        plot(PointList(INDEX_OF_KEY_PTS,2),PointList(INDEX_OF_KEY_PTS,3),'r.','MarkerSize',5);

        % Plot the ellipse
        plot(ellipse(2,:),ellipse(1,:));
        
        % Plot the center of the ellipse
        plot(currCenter(1),currCenter(2),'g.');

        % Plot any existing Potential feature points
        if (numel(INDEX_OF_KEY_PTS_POT)>0)
            plot(PointList(INDEX_OF_KEY_PTS_POT,2),PointList(INDEX_OF_KEY_PTS_POT,3),'bo','MarkerSize',5);
        end
        
        if (makeMovie == 0)
            pause(0.1);
        else
            F = getframe(gca);
            mov = addframe(mov,F);
        end
    end

    % check for motion of all potential KLT feature points. If there are no
    % motion for the past TIME_WINDOW frames removie it, because it is most
    % likely an occulded KLT feature reapearing after the object moves over
    % it.
    if (distTimeIndex > TIME_WINDOW)
        j = 1;
        while j<=numel(INDEX_OF_KEY_PTS_POT)
            % find the distance traved in the TIME_WINDOW as the sum of all
            % displacement between two frames
            totalDisplacement = PastDist(INDEX_OF_KEY_PTS_POT(j),:);
            totalDisplacement = sum(totalDisplacement);
            
            % if there are no displacement remove point from both
            % INDEX_OF_KEY_PTS. ****** IDEALY WE SHOULD REMOVE IT FROM
            % INDEX_OF_KEY_PTS_POT AS WELL ******
            if (totalDisplacement<=0)
                
                % plot the point in red to show it is no longer part of
                % INDEX_OF_KEY_PTS
                plot(PointList(INDEX_OF_KEY_PTS_POT(j),2),PointList(INDEX_OF_KEY_PTS_POT(j),3),'ro');
                
                % remove from INDEX_OF_KEY_PTS
                k = 1;
                while (k <= numel(INDEX_OF_KEY_PTS))
                    if (INDEX_OF_KEY_PTS(k) == INDEX_OF_KEY_PTS_POT(j))
                        if k == 1
                            INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS(2:end);
                        elseif k == numel(INDEX_OF_KEY_PTS)
                            INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS(1:end-1);
                        else
                            INDEX_OF_KEY_PTS = [INDEX_OF_KEY_PTS(1:k-1) INDEX_OF_KEY_PTS(k+1:end)];
                        end
                        k = numel(INDEX_OF_KEY_PTS) + 1;
                    end
                    k = k + 1;
                end
                
            end
            j = j + 1;
        end
    end
    
    frameInfo(frameInfoIndex).INDEX_OF_KEY_PTS = INDEX_OF_KEY_PTS;
    frameInfo(frameInfoIndex).INDEX_OF_KEY_PTS_POT = INDEX_OF_KEY_PTS_POT;
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