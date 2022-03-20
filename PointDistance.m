%   Calculation of pairs of points located too near
%
%   Description: programme calcutale distance between points to find out if
%                pairs of points are too near or not
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, February
%   Last change.....: 2018, August
%
%
%   Input:
%   --------------------------------------------------------
%   matrix   matrix of positions of basepairs on curve
%
%   Output:
%   --------------------------------------------------------
%   matrix   matrix of positions of pairs of basepairs located too near

function [au] = PointDistance(points)
[N,~] = size(points);
a = 1;
% critical distance between basepairs
critical_distance=20;
% no need to check first and last six basepairs in neighborhood
for k=7:N
    for l=1:k-7
        % comparing distance on x axis
        if(abs(points(k,1)-points(l,1))<critical_distance)
            % comparing distance on y axis
            if(abs(points(k,2)-points(l,2))<critical_distance)
                % comparing distance on z axis
                if (abs(points(k,3)-points(l,3))<critical_distance)
                    if(sqrt(sum((points(k,:)-points(l,:)).^2))<critical_distance)
                        % writing down position of
                        au(a,:) = [k l sqrt(sum((points(k,:)-points(l,:)).^2))];
                        a = a+1;
                    else
                        continue
                    end
                else
                    continue
                end
            else
                continue
            end
        else
            continue
        end
    end
    % in case of one distance being bigger than critical distance, no need of
    % continuing  because of basepairs located in save distance
end
% checking distance between 6 last and 6 first basepairs 
[b,~] = size(au);
for e=1:b
    if(au(e,1)-au(e,2)>N-7)
        au(e,:) = zeros(1,3);
    else
        continue
    end
end
