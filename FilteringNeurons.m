
%% building template

template = TrainingNeurons();

%% Filtering Nuerons

improt = imread('PV ChR2 Animal 5 - Less Noise.tif');

filter1 = fspecial('gaussian', 15, 0.75); %smaller standard deviation, stronger filter 
filter2 = fspecial('gaussian', 15, 4);

improt2 = double(improt);

improt_f = imfilter(improt2, filter1);
im_f = imfilter(improt2, filter2);


improt_fg = improt_f - im_f;
%improt_bg = improt_f - improt_fg;
improt_fg = mat2gray(improt_fg);
improt_fg2 = im2bw(improt_fg,0.3);
improt_fg2 = imcomplement(improt_fg2);
A = improt_fg2;
improt_fg2 = imtophat(improt_fg2, strel('disk', 3)); %morphological top-hat filtering on the grayscale image


S= regionprops(improt_fg2,'Centroid');
centroids = cat(1, S.Centroid);
%improt1M = insertMarker(improtcrop,centroids);

window = zeros(11,11, size(centroids,1));
coefficient = zeros(size(centroids,1));
result = zeros(size(centroids));
Rtest = zeros(size(centroids,1),1);
count=1;

for i=1:size(centroids,1)
    crow = centroids(i,2);
    ccol = centroids(i,1);
    
    window(:,:,i)= improt(crow-5:crow+5,ccol-5:ccol+5); % 11*11 window centered at (6,6) 
    R = corrcoef(template,window(:,:,i));
    Rtest(i) = R(1,2);
    if R(1,2) >= 0.7
        result(count,:) = centroids(i,:);
        count = count +1;
    end

end

result = result(1:count-1,:);
resultM = insertMarker(improt,result);
figure(1);imshow(improt,[]);
figure(2);imshow(resultM,[]);title(['\fontsize{13} Number of Neuron: ' num2str(size(result,1))],'FontWeight','bold','Color','r');


%% Iterating the Image with Template


improt = imread('PV ChR2 Animal 5 - Less Noise.tif');

filter1 = fspecial('gaussian', 15, 0.75); %smaller standard deviation, stronger filter 
filter2 = fspecial('gaussian', 15, 4);

improt2 = double(improt);

improt_f = imfilter(improt2, filter1);
im_f = imfilter(improt2, filter2);
improt_fg = improt_f - im_f;
improt_fg = mat2gray(improt_fg);

maxResponse = ones(size(improt_fg))*-10;


normCorr =  normalized_correlation(improt_fg,template)>0.8;
higherMax = (normCorr > maxResponse);
maxResponse(higherMax)= normCorr(higherMax);

maxResponse = logical(maxResponse);
area = regionprops(maxResponse,'Centroid');
centroids = cat(1, area.Centroid);
    
result = insertMarker(improt_fg,centroids,'+');
figure(1);imshow(improt);
figure(2);imshow(result);title(['\fontsize{13} Number of Neuron: ' num2str(size(centroids,1))],'FontWeight','bold','Color','r');


