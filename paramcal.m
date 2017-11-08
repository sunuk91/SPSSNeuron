

function [L1,L2,angle,xmajor,ymajor] = paramcal(img,centroids)


%L2 = dist(NucMembrane, neurons)
%L1 = dist(Centroid, neurons)
%radialposition = L1/(L1+L2)
%alpha = angle between major axis and neuron



[BWfinal, perim]=CellMask(img);
stats = regionprops(BWfinal, 'Centroid', 'Orientation','MajorAxisLength','MinorAxisLength');
xmajor = stats.Centroid(1) + [-1 1]*(stats.MajorAxisLength/2)*cosd(stats.Orientation); %xMajorAxis
ymajor = stats.Centroid(2) + [-1 1]*(stats.MajorAxisLength/2)*sind(stats.Orientation); %yMajorAxis

%Majoraxis : Length (in pixels) of the major axis of the ellipse that has the same normalized second central moments as the region, returned as a scalar.

L1 = sqrt(sum(bsxfun(@minus,centroids,stats.Centroid).^2,2)); %distance from centroid to neurons
L2 = zeros(size(centroids,1),1);
angle = zeros(size(centroids,1),1);

v1 = [xmajor(1), ymajor(1)]-[xmajor(2),ymajor(2)];
    for i=1:size(centroids,1)

     dist02 = sqrt(sum(bsxfun(@minus,perim,centroids(i,:)).^2,2));
     L2(i) = min(dist02);
    
     v2 = centroids(i,:)-stats.Centroid;
   
     if v2(2)>0
         angle(i) = 360- atan2d(abs(det([v1;v2])),dot(v1,v2));
     else
         angle(i) = atan2d(abs(det([v1;v2])),dot(v1,v2));
     end
    end

end
