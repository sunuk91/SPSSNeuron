%Building a Cell Mask
function [BWfinal,point] =CellMask(image)

improt = image;
%improt = imread('PV ChR2 Animal 5 - Less Noise.tif');
%filter2 = fspecial('gaussian', 15, 5);

%improt = double(improt);
%im_f = imfilter(improt, filter2);
im_f = double(improt);
[~,threshold] = edge(im_f,'sobel');
fudgeFactor = 0.5;
BWs = edge(im_f,'sobel', threshold*fudgeFactor);

se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs, [se90 se0]);
BWdfill = imfill(BWsdil,'holes');
BWnobord = imclearborder(BWdfill,4);
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWfinal = imerode(BWfinal,seD);

%calculate major axis and minor axis 
cc = bwconncomp(BWfinal);
stats = regionprops(BWfinal,'MajorAxisLength');
idx = find([stats.MajorAxisLength] > 100);
BWfinal = ismember(labelmatrix(cc),idx);

%stats = regionprops(BWfinal, 'Centroid', 'Orientation','MajorAxisLength','MinorAxisLength');

%xMajor = stats.Centroid(1) + [-1 1]*(stats.MajorAxisLength/2)*cosd(stats.Orientation);
%yMajor = stats.Centroid(2) + [-1 1]*(stats.MajorAxisLength/2)*sind(stats.Orientation);

%xMinor = stats.Centroid(1) + [-1 1]*(stats.MinorAxisLength/2)*sind(stats.Orientation);
%yMinor = stats.Centroid(2) + [-1 1]*(stats.MinorAxisLength/2)*cosd(stats.Orientation);



perim = bwperim(BWfinal);
[x,y] = find(perim==1);

point = [x y];

end
