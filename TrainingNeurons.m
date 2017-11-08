%Cfos Image Filter
function [template] = TrainingNeurons()


filepath = './Reference';

RI11 = imread([filepath '/Reference#1.tif']);
RI22 = imread([filepath '/Reference#2.tif']);
RI33 = imread([filepath '/Reference#3.tif']);

filter1 = fspecial('gaussian', 15, 1); %smaller standard deviation, stronger filter 
filter2 = fspecial('gaussian', 15, 4);

improt1 = double(RI11);

improt_f = imfilter(improt1, filter1);
im_f = imfilter(improt1, filter2);


improt_fg = improt_f - im_f;
%improt_bg = improt_f - improt_fg;
improt_fg = mat2gray(improt_fg);
improt_fg2 = im2bw(improt_fg,0.3);
improt_fg2 = imcomplement(improt_fg2);
improt_fg2 = imtophat(improt_fg2, strel('disk', 3));

S1= regionprops(improt_fg2,'centroid');
centroids1 = cat(1, S1.Centroid);
RI1Final = insertMarker(RI11,centroids1);

%figure(1);imshow(RI1Final);title(['\fontsize{12} Image01 Number of Neuron: ' num2str(size(centroids1,1))],'FontWeight','bold','Color','r');


improt2 = double(RI22);

improt_f = imfilter(improt2, filter1);
im_f = imfilter(improt2, filter2);


improt_fg = improt_f - im_f;
%improt_bg = improt_f - improt_fg;
improt_fg = mat2gray(improt_fg);
improt_fg2 = im2bw(improt_fg,0.3);
improt_fg2 = imcomplement(improt_fg2);
improt_fg2 = imtophat(improt_fg2, strel('disk', 3));

S2= regionprops(improt_fg2,'centroid');
centroids2 = cat(1, S2.Centroid);
RI2Final = insertMarker(RI22,centroids2);

%figure(2);imshow(RI2Final);title(['\fontsize{12} Image01 Number of Neuron: ' num2str(size(centroids2,1))],'FontWeight','bold','Color','r');


improt3 = double(RI33);

improt_f = imfilter(improt3, filter1);
im_f = imfilter(improt3, filter2);


improt_fg = improt_f - im_f;
%improt_bg = improt_f - improt_fg;
improt_fg = mat2gray(improt_fg);
improt_fg2 = im2bw(improt_fg,0.3);
improt_fg2 = imcomplement(improt_fg2);
improt_fg2 = imtophat(improt_fg2, strel('disk', 3));

S3= regionprops(improt_fg2,'centroid');
centroids3 = cat(1, S3.Centroid);
RI3Final = insertMarker(RI33,centroids3);

%figure(3);imshow(RI3Final);title(['\fontsize{12} Image01 Number of Neuron: ' num2str(size(centroids3,1))],'FontWeight','bold','Color','r');



numref = size(centroids1,1)+size(centroids2,1)+size(centroids3,1);
window = zeros(11,11,numref);

%centroids1, centroids2, centroids3
%RI11, RI22, RI33 cropped original images
centroids1 = round(centroids1);
centroids2 = round(centroids2);
centroids3 = round(centroids3);


marginrow1=6;
marginrow2=size(RI11,1)-6+1;
margincol1=6;
margincol2=size(RI11,2)-6+1;




%for 1:size(centroids1,1)
index=1;
count=1;
RI11=mat2gray(RI11);
for i=1:size(centroids1,1)
    
    crow=centroids1(i,2);
    ccol=centroids1(i,1);
    if((crow>marginrow1) && (crow<marginrow2)) 
        if ((ccol>margincol1) && (ccol<margincol2))
            window(:,:,index) = RI11(crow-5:crow+5,ccol-5:ccol+5);
            index = index+1;
        end
    end
    count=count+1;
    
end

marginrow1=6;
marginrow2=size(RI22,1)-6+1;
margincol1=6;
margincol2=size(RI22,2)-6+1;

RI22 = mat2gray(RI22);
for i=1:size(centroids2,1)
    crow =centroids2(i,2);
    ccol = centroids2(i,1);
    if((crow>marginrow1) && (crow<marginrow2)) 
        if ((ccol>margincol1) && (ccol<margincol2))
            window(:,:,index) = RI22(crow-5:crow+5,ccol-5:ccol+5);
            index = index+1;
        end
    end
    count = count+1;
end

marginrow1=6;
marginrow2=size(RI33,1)-6+1;
margincol1=6;
margincol2=size(RI33,2)-6+1;
RI33 = mat2gray(RI33);

for i=1:size(centroids3,1)
    crow =centroids3(i,2);
    ccol = centroids3(i,1);
    if((crow>marginrow1) && (crow<marginrow2)) 
        if ((ccol>margincol1) && (ccol<margincol2))
            window(:,:,index) = RI33(crow-5:crow+5,ccol-5:ccol+5);
            index = index+1;
        end
    end
    count = count+1;
end

window = window(:,:,1:index-1); %Reference Windows Completed 
template = mean(window,3);%build a template by taking means of windows. 

end 
%Create a distribution that fits the window references 
%Sliding Window filtering with certain threshold.










    


