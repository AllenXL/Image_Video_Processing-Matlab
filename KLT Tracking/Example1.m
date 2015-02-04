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
% Description:  Example1.m
%               Example of using the kltTrack code. It is assumed the
%               feature list has been obtained using the C++ KLT
%               implementaiton.
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
%
% OUTPUTS:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clear all; % closes any lost handels to avi
clc

% directory in which the C++ tracked feature list are stored
dir = '.\Walk1\';
% directory in which the pgm format frame images are stored
dir2 = '.\Walk1Frames\';

% the file name of frame image as well as feature list
% It is assumed the file name format will be
%         [fileStart1 num2str(frameNum) '.txt'] for feature list
%         [fileStart1 num2str(frameNum) '.pgm'] for frame image
fileStart1 = 'Walk1Frame';

% the spread of the ellipse on the start frame
h = [71 71];
% the center location of ellipse on the start frame
y = [268 227];
% orientation of the ellipse
angle = 0;

% the frame sequence to use
startFrame = 260;
endFrame = 354;

% KLT feature tollerance, all feature values less than TOL are ignored
TOL = 945;

% the time window in which to check if no motion occurs in the KLT feature
% If there are no motion for TIME_WINDOW frames then the feature point is
% omitted from the feature points being tracked.
TIME_WINDOW = 7;

SHOW_FIG = 1;

[frameInfo]  = kltTrack(dir, dir2, fileStart1, h, y, startFrame, ...
    endFrame, TOL, angle, TIME_WINDOW, SHOW_FIG, 'TestSeq1_adv.avi',3);