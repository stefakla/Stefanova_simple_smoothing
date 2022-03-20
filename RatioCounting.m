%	  Counting ratio of lengths of curve before and after smoothing
%
%   Description: programme is counting ratio of lengths of curve before and
%                after smoothing
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, July
%   Last change.....: 2018, July
%
%
%   Input:
%   --------------------------------------------------------
%   matrix    matrix of positions of points before smoothing
%   matrix    matrix of positions of points after smoothing
%
%   Output:
%   --------------------------------------------------------
%   number    ratio of lengths of curve before and after smoothing 

function ratio_length = RatioCounting(enter,smooth_point)
p = enter([2:end 1],:)-enter;
np = sum(sqrt(sum(p.^2,2)));
z = smooth_point([2:end 1],:)-smooth_point;
nz = sum(sqrt(sum(z.^2,2)));
ratio_length = np/nz;
