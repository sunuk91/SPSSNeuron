clear;clc;
%% Medfilter+Wiener2+Im2bw

improt = imread('PV ChR2 Animal 5.tif');
%figure(5);imshow(improt);
improtcrop = imcrop(improt, [size(improt,1)/7,size(improt,2)/3,size(improt,1)/2,size(improt,2)/4]);

[improtcrop, rect] =imcrop(improtcrop);

improt1 = medfilt2(improtcrop); %Median Filtering with 3*3 kernels
improt1 = wiener2(improt1,[8 8]); %Adaptive Noise-Removal Filtering (Smoothing)                                   
improt1 = imsharpen(improt1,'Radius',2,'Amount',1.2); %Gaussian Lowpass Filter (Sharpen Edge)
test=improt1;
improt1 = im2bw(improt1,0.3); %Black and White Thresholding 

%test1 = im2bw(improt1,0.3);
%test2 = im2bw(improt1,0.2);
improt1 = imcomplement(improt1); %Image Complement
improt1 = imtophat(improt1, strel('disk', 3)); %morphological top-hat filtering on the grayscale image
figure(2);imshow(improt1);

S= regionprops(improt1,'centroid');
centroids = cat(1, S.Centroid);
A = zeros(size(centroids));

count = 1;
for i=1:length(centroids)
   if (centroids(i,1)>10 && centroids(i,1)<size(improt1,2)-15)&&(centroids(i,2)>15 &&centroids(i,2)<size(improt1,1)-10)    
       A(count,:) = centroids(i,:);
       count = count+1;
   end    
end

A=A(1:count-1,:);


improt1M = insertMarker(improtcrop,A);



figure(3);imshow(improt1M);title(['\fontsize{13} Number of Neuron: ' num2str(size(A,1))],'FontWeight','bold','Color','r');



%% SegmentProt

improt = imread('PV ChR2 Animal 5.tif');
improtcrop = improt;
%[improtcrop, rect] =imcrop(improt);


filter1 = fspecial('gaussian', 15, 0.75); %smaller standard deviation, stronger filter 
filter2 = fspecial('gaussian', 15, 4);

improt2 = double(improtcrop);

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
improt1M = insertMarker(improtcrop,centroids);



figure(1);imshow(improt_fg2);
figure(2);imshow(improt_fg,[]);
figure(4); imshow(improt1M);imshow(improt1M);title(['\fontsize{13} Number of Neuron: ' num2str(size(centroids,1))],'FontWeight','bold','Color','r');



%% Test Section

improt = imread('PV ChR2 Animal 5.tif');
improtcrop = imcrop(improt, [size(improt,1)/7,size(improt,2)/3,size(improt,1)/2,size(improt,2)/4]);

figure(1);imshow(improtcrop);
improt1 = medfilt2(improtcrop); %Median Filtering with 3*3 kernels
improt1 = wiener2(improt1,[5 5]); %Adaptive Noise-Removal Filtering (Smoothing)                                   
improt1 = imsharpen(improt1,'Radius',2,'Amount',1.2); %Gaussian Lowpass Filter (Sharpen Edge)
%improt1 = im2bw(improt1,0.1); %Black and White Thresholding 
%improt1 = imcomplement(improt1); %Image Complement
%prot1 = imtophat(improt1, strel('disk', 3));

%figure(2);imhist(improtcrop);
improt1(improt1>15)=250;
improt1 = imcomplement(improt1); %Image Complement
prot1 = imtophat(improt1, strel('disk', 2));

figure(2);imshow(prot1);
