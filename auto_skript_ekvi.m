%	Counting positions of atoms of basepairs on curve with given sequence of
%	nucleobases
%
%   Description: script is running programmes for smoothing a curve and
%                counting positions of basepairs on curve with given sequence of
%                nucleobases and is checking the results
%
%   Author.....: Klara Stefanova
%
%   Created.........: 2018, April
%   Last change.....: 2018, July
%
%
%   Input:
%   --------------------------------------------------------
%   folder    place where files with measured points are saved
%   files .dat files with measured dat, their names' format is integer from
%              0 to 999 completed by zeros to have 3 digits
%   number    the number of interations in programme puleni_py.m
%   number    the precision of deciding of smoothed points define a plane or not
%   file      sequence of nucleobases
%
%   Output:
%   --------------------------------------------------------
%   pdb file  characteristics of atoms of basepairs on curve prepared for
%              being writen down to pdb file

clc; clear all;
% input: In which folder are your data saved?
% plasmid should be replaced by name of plasmid which will be smoothed: pUC19,
% pBR322, pKLAC2
file = 'data/plasmid';
% input: How many files will be smoothed?
F = 100;
% input: Which is the number of the beginning file?
B = 400;
% input: number of iterations
% recommended: pUC19: 7, pBR322: 8, pKLAC2: 8
p = 7;
% precision of deciding of smoothed points define a plane or not
g = 5;
% input: What is the path to your sequence of nucleobases
% plasmid should be replaced by name of plasmid which will be smoothed: pUC19,
% pBR322, pKLAC2
seq = 'sequence/plasmid.txt';
sequence = loadSequence(seq);
% number of basepairs
[~,N] = size(sequence);
% The path to pdb files representing adenine, cytosine, guanine and thymine?
way = 'PDB/A.pdb';
bas.A = pdbread(way);
way = 'PDB/C.pdb';
bas.C = pdbread(way);
way = 'PDB/G.pdb';
bas.G = pdbread(way);
way = 'PDB/T.pdb';
bas.T = pdbread(way);
% matrix for controlling lenght and angles and ratio
lenghts = zeros(F,3);
min_cos = zeros(F,2);
elengths = zeros(F,2);
pupo = zeros(F,1);
for i=B:B+F-1
     j = i - B;
    % correction of number of iterations for pBR322 plasmid
    switch i
          case 850
              p = 7;
    end
    % correction of number of iterations for pKLAC2 plasmid
    switch i
         case 930
             p = 9;
    end
    disp(i)
    % change
    filename = sprintf('%s/%04i.dat',file,i);
    incurve = dlmread(filename);
    % correction of precision of deciding if three points define a plane or
    % not for pKLAC2 plasmid
    switch i
         case {1,77,209,227,303,931}
             g = 4;
    end
    % running programme IterativeSmooth.m
    smoothpoint = IterativeSmooth(p,incurve,g);
    pupo(j+1,1) = RatioCounting(incurve,smoothpoint);
    % running programme LengthScaling.m
    scalepoint = LengthScaling(smoothpoint,N);
    % running programme ekvidistant.m
    ekvipoint = ekvidistant(scalepoint,N);
    v = ekvipoint([2:end 1],:)-ekvipoint;
    n = sqrt(sum(v.^2,2));
    % saving minimum and maximum of distance between points on curve with
    % equidistant points
    lenghts (j+1,:) = [i min(n) max(n)];
    % running programme angles.m
    cos = angles(ekvipoint);
    % saving minimum of cosinus of angle
    min_cos (j+1,:) = [i min(cos)];
    % running programme PointDistance.m
    space = PointDistance(ekvipoint);
    % saving position of point located too near
    elengths(j+1,:) = [i max(space(:,3))];
    % running programmme AtomPosition.m
    pdb_array = AtomPosition(ekvipoint,sequence,bas);
    % saving pdb file with positions of atoms on curve
    ID = sprintf('%s%03i.pdb','pdb_BR322_',i);
    fileID = fopen(ID,'w');
    [~,n] = size(pdb_array);
    for l = 1:n
        fprintf(fileID,'%s\n',pdb_array{l});
    end
    fclose(fileID);
end
% checking distance between base pairs
[A,k] = min(lenghts(:,2));
[D,l] = max(lenghts(:,3));
if A>=3.2 && D<=3.4
    disp('distance between base pairs OK')
else
    X = ['problem with minimum distance ',num2str(A),' in file ',num2str(k-1+B),...
        ' and with maximum ',num2str(D), ' in file ',num2str(l-1+B)];
    disp(X)
end
% checking cosinus of angles
[C,m] = min(min_cos(:,2));
if C>=0.95
    disp('angles OK')
else
    X = ['problem with angles in file ', num2str(m-1+B)];
    disp(X)
end
% checking too near points
E = elengths(:,2);
D = find(E>0.00001);
disp('there is a problem with too near points in files')
disp(D-1)
% checking ratio of lengths of unsmoothed and smoothed curves
[Q,x] = min(pupo);
[S,y] = max(pupo);
if Q>=0.98 && S<=1.02
    disp('distance between base pairs OK')
else
    X = ['problem with minimum ratio ',num2str(Q),' in file ',num2str(x-1+B),...
        ' and with maximum ',num2str(S), ' in file ',num2str(y-1+B)];
    disp(X)
end
