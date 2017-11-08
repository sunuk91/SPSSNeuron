                                              %Building a Cell Mask
function [rpoint]=CellMask(image)

improt = image;
%improt = imread('PV ChR2 Animal 4 - Less Noise.tif');
filter2 = fspecial('gaussian', 15, 5);

%improt = double(improt);
%im_f = imfilter(improt, filter2);
im_f = improt;
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

perim = bwperim(BWfinal);
[x,y] = find(perim==1);
point = [x y];
circum = size(x,1);
interval = floor(circum/100);
rpoint = zeros(100,2);
index=1;
for i=1:size(rpoint,1)
    rpoint(i,:)=point(index,:);
    index = index+interval;
end

test = zeros(size(BWfinal));
%{
for i=1:size(rpoint,1)
    test(rpoint(i,1),rpoint(i,2))=1;
    %imshow(test);
    %pause(0.01);
end
%}

for i=1:size(point,1)/10
    test(point(i,1),point(i,2))=1;

   
end
%BWoutline = bwperim(BWfinal);
%improt(BWoutline)=0;


rpoint = [rpoint(:,2) rpoint(:,1)];
%reference = cat(1, rpoint);
testfinal = insertMarker(double(perim),rpoint);


%figure(1);imshow(perim);
%figure(2);imshow(BWfinal);

end