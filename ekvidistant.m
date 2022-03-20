%   Position calculation of basepirs on smoothed and scalled curve
%
%   Destription: programme calcalates position of basepairs on smoothed
%                and scalled curve based on distance between basepairs
%
%   Author.....: Klara Stefanova
%
%   Created..........: 2018, February
%   Last change......: 2018, August
%
%   Input:
%   --------------------------------------------------------
%   matrix   matrix of positions of points on smoothed and scalled curve
%   number   number of basepairs on curve
%
%   Output:
%   --------------------------------------------------------
%   matrix   matrix of positions of basepairs

function point_ekvidistant = ekvidistant(enter_point,N)
% matrix of calculated positiions of basepairs
point_e = zeros(N+1,3);
% first point of input same with position of first basepair
point_e(1,:) = enter_point(1,:);
[m,~] = size(enter_point);
% vectors reprezenting connection between points
vector1 = enter_point([2:end 1],:)-enter_point;
% matrix of vectors' norms
norm1 = sqrt(sum(vector1.^2,2));
% beginnimg index of matrix of basepairs for for loop
l = 2;
% distance betweein basepairs
d = 3.4;
r = d;
vector2 = [vector1; vector1];
norm2= [norm1; norm1];
enter1 = [enter_point;enter_point];
while (l<N+5001)
    for k = 2:2*m
        % reduction of distance d for next if in loop
        if norm2(k) < r
            r = r-norm2(k);
            % norm same with distance between two points, basepair located on the last point of vector
        elseif norm2(k) == r
            point_e(l,:) = enter1(k+1,:);
            % increase of index of matrix of basepairs (could lead to transcriptions)
            l = l+1;
            % restart of distance r to original value
            r = d;
            % necessary to calculate point between k and k+1 point of input
            % with distance d from presivious basepair
        else
            % recalculation of norm necessary because of unnormed vector
            r1 = (1/norm2(k))*r;
            % calcution of point on curve with given distance from first point
            % on vector
            point_e(l,:) = enter1(k,:)+r1*vector2(k,:);
            % increase of index of matrix of basepairs (could lead to transcriptions)
            l = l+1;
            % restart of distance r to original value
            a = norm2(k)-r;
            r = d-a;
        end
    end
end
% writing down poisitions of calculated positions of basepairs
point_ekvidistant = point_e([N+1 2:N],:);
