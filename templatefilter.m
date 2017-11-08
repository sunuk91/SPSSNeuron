%Template Matching
function [result,centroids]=templatefilter(image,template)


filter1 = fspecial('gaussian', 15, 0.75); %smaller standard deviation, stronger filter 
filter2 = fspecial('gaussian', 15, 4);


improt_f = imfilter(image, filter1);
im_f = imfilter(image, filter2);
improt_fg = improt_f - im_f;
improt_fg = mat2gray(improt_fg);

maxResponse = ones(size(improt_fg))*-10;
normCorr =  normalized_correlation(improt_fg,template)>0.85;
higherMax = (normCorr > maxResponse);
maxResponse(higherMax)= normCorr(higherMax);

maxResponse = logical(maxResponse);
area = regionprops(maxResponse,'Centroid');
centroids = cat(1, area.Centroid);
    
result = insertMarker(improt_fg,centroids,'+','size',7);

end


