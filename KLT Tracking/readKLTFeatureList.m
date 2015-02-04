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
% Description:  readKLTFeatureList.m
%               Will read the feature location and value as outputed by the
%               KLT tracker code provided on the referenced webpage.
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
%          fileName - the name of the .txt file containting the feature
%                     list
%
% OUTPUTS:
%          PointList - nx4 the feature List for n KLT features
%                      [ID colLoc rowLoc value]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [PointList] = readKLTFeatureList(fileName)

fid = fopen(fileName, 'r');

% there are 34 string before the data begins
C = textscan(fid, '%s', 34);
text = C{:};
% of the 1st 34 string the 30th string is the number of feature points
numPoints = str2num(text{30});

% read the number of feature points
C2 = textscan(fid, '%f | (%f,%f)=%f',numPoints);

% convert the structs to array of double
PointList = [C2{1} C2{2} C2{3} C2{4}];

clear C text numPoints C2;

fid = fclose(fid);