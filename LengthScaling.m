%   Scalling length of smoothed curve on length corresponding to the number
%   of basepairs
%
%   Description: programme recalcutale lenght of smoothed curve on legnth
%                corresponding to the number of basepairs
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, February
%   Last change.....: 2018, August
%
%
%   Input:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on smoothed curve
%   number   number of basepairs
%
%   Output:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on scalled and smoothed curve

function point_scale = LengthScaling(enter,N)
% size of input matrix
[m,~]=size(enter);
% vectors represeting connection between points
vektor = enter([2:m 1],:)-enter;
% matrix of norms of vectors
norm1 = sqrt(sum(vektor.^2,2));
% length of smoothed curve
length_enter = sum(norm1);
% length of curve based on the number of basepairs
length_base = N*3.4;
% ratio of lenghts
length_ratio = length_base/length_enter;
% scalling coordinates
point_scale = length_ratio*enter;
