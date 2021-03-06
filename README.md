# Development of detailed dynamic models of plasmid DNA

This code is part of bachelor thesis "Development of detailed dynamic models of plasmid DNA" written by Klára Stefanová,
Faculty of Nuclear Sciences and Physical Engineering at the Czech Technical University in Prague, 2019.

This work was created in frame of the Czech Science Foundation project No. 17-03403Y.

This work is pending publication, therefore at this moment this repository is considered confidential by the authors.

## auto_skript_ekvi

The auto_skript_ekvi.m is an application which can smooth points in accordance with Kummerle and Pumplon, 2005,
Eur Biophys J 34: 13-18 and compute positions of atoms on DNA loop with given sequence.

### Prerequisites
The application is provided in the form of source code. To compile and use it, a computer with Matlab software is needed. The code has been tested with versions 2018a and 201(5/6)b on a Windows system.

Detailed instructions how to get a Matlab sotfware can be found at the [Matlab website](https://uk.mathworks.com/products/matlab.html).

### Running

Open Matlab and go to the folder, where auto_skript_ekvi.m is saved. (Let us say it will be in ~/Documents/).

The lines starting with \% are comments

Following part of auto_skript_ekvi.m is meant for being changed. Here you input some information about your loop to work properly for your example. You must input folder in which your files are saved. The files with data must be saved in .dat format and their names must be in form of integer form 0 to 999 and the number should have 4 digits, for example: 0002.dat, 0506.dat, 0156.dat, and you need to input the amount of numbers to be smoothed and the number of beginning file which will be smoothed first. But if data files have names with more or less digits than 3, you can change it in the following part of code. Than you must input the number of iterations. We reccomend to smooth your curve to have aproximately 10 times more points than the number of basepairs, for this example we iterated for 7 or 8 times. Another parametre which must be given to programme IterativeSmooth.m is the precision of deciding of smoothed points define a plane or not. Without corrections we used 5. The last thing you must input is the path to the file where your sequence of nucleobases is located. The pdb file with atoms of adenine, cytosine, gaunine and thymine are provided with this application. If you want to use yours, you also must change the path to them.

```
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
p = 8;
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
```

The smoothing and computig process for all your files will run according to this part of auto_skript_ekvi.m. Genereted pdb files of positions of atoms will be saved into the same folder as auto_skript_ekvi.m. In this part of script following programmes are used: IterativeSmooth.m, LengthScaling.m, ekvidistant.m, angles.m, PointDistance.m and AtomPosition.m. If your data files have more or less than 3 digits in their name you must change it on the lines under the comment with word change. There also correction for structures in comments.

```
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
```

In the end of the script there is a check of size of angles, ratio of lengths of unsmoothed and smoothed curves and distances between points. Information messeges will be displayed in command window.

```
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
    X = ['problem with angles in file', num2str(m-1)];
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
```

### Contact

If you have any comments or suggestions, we'll be glad to hear them.

Klára Stefanová, [stefakla@fjfi.cvut.cz](mailto://stefakla@fjfi.cvut.cz)

Martin Šefl, [sefl@ujf.cas.cz](mailto://sefl@ujf.cas.cz)

Václav Štěpán, [stepan@ujf.cas.cz](mailto://stepan@ujf.cas.cz)
