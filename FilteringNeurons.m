
%% building template


template = TrainingNeurons();


%% Iterating the Image with Template

img1 = imread('PV ChR2 Animal 4 - Less Noise.tif');
img1 = double(img1);
[result1,centroids1] = templatefilter(img1,template);
%imshow(result);title(['\fontsize{13} Number of Neuron: ' num2str(size(centroids,1))],'FontWeight','bold','Color','r');

img2 = imread('PV ChR2 Animal 5 - Less Noise.tif');
img2 = double(img2);
[result2,centroids2] = templatefilter(img2,template);

img3 = imread('PV ChR2 Animal 2.tif');
img3 = double(img3);
[result3,centroids3] = templatefilter(img3,template);

%% Neasrt Neighbor 
%each centroids and rpoints
%L2 = dist(NucMembrane, neurons)
%L1 = dist(Centroid, neurons)
%radialposition = L1/(L1+L2)
%alpha = angle between major axis and neuron


[L1A,L2A,angleA,xMajor1,yMajor1] = paramcal(img1,centroids1);
radialA = L1A./(L1A+L2A);


[L1B,L2B,angleB,xMajor2,yMajor2] = paramcal(img2,centroids2);
radialB = L1B./(L1B+L2B);


[L1C,L2C,angleC,xMajor3,yMajor3] = paramcal(img3,centroids3);
radialC = L1C./(L1C+L2C);

%imshow(result);hold on;
%line(xMajor1,yMajor1);



%% Principle Component Analysis

%Fit probability density for all pixels for all cells 
%radial = [radialA;radialB;radialC];
%figure(1);histfit(radial, round(size(radial,1)/100),'kernel');title('raidal distance');

%angle = [angleA;angleB;angleC];
%figure(2);histfit(angle, round(size(radialA,1)/100),'kernel');title('raidal distance');

%Learn PD for all class 

animal1 = [L1A,L2A,radialA,angleA]';
animal2 = [L1B,L2B,radialB,angleB]';
animal3 = [L1C,L2C,radialC,angleC]';

%animal1 PCA
[M,N] = size(animal1);
mn = mean(animal1,2);
animal1 = animal1 - repmat(mn,1,N);
covariance = 1/(N-1)*(animal1)*animal1';
[PC, V] = eig(covariance);
V = diag(V);

[~, rindices] = sort(-1*V);
V1 = V(rindices);
PC1 = PC(:,rindices);
T1=PC1'*animal1;


%animal2 PCA
[M,N] = size(animal2);
mn = mean(animal2,2);
animal2 = animal2 - repmat(mn,1,N);
covariance = 1/(N-1)*(animal2)*animal2';
[PC, V] = eig(covariance);
V = diag(V);

[~, rindices] = sort(-1*V);
V2 = V(rindices);
PC2 = PC(:,rindices);
T2=PC2'*animal2;

%animal3 PCA
[M,N] = size(animal3);
mn = mean(animal3,2);
animal3 = animal3 - repmat(mn,1,N);
covariance = 1/(N-1)*(animal3)*animal3';
[PC, V] = eig(covariance);
V = diag(V);

[~, rindices] = sort(-1*V);
V3 = V(rindices);
PC3 = PC(:,rindices);
T3=PC3*animal3;

T =[T1(:,1),T2(:,1),T3(:,1)];


%% plot


radial = [radialA;radialB;radialC];
figure(1);subplot(2,2,1);histfit(radial, round(size(radial,1)/100),'kernel');title('radial(3 animal)');

subplot(2,2,2);histfit(radialA, round(size(radialA,1)/100),'kernel');title('radialA (animal#4)');
subplot(2,2,3);histfit(radialB, round(size(radialB,1)/100),'kernel');title('radialB (animal#5)');
subplot(2,2,4);histfit(radialC, round(size(radialC,1)/100),'kernel');title('radialC (animal#2)');


L1 = [L1A;L1B;L1C];
figure(2);subplot(2,2,1);histfit(L1, round(size(L1,1)/100),'kernel');title('L1(3 animal)');
subplot(2,2,2);histfit(L1A, round(size(L1A,1)/100),'kernel');title('L1 (animal#4)');
subplot(2,2,3);histfit(L1B, round(size(L1B,1)/100),'kernel');title('L1 (animal#5)');
subplot(2,2,4);histfit(L1C, round(size(L1C,1)/100),'kernel');title('L1 (animal#2)');

L2 = [L2A;L2B;L2C];
figure(3);subplot(2,2,1);histfit(L2, round(size(L2,1)/100),'kernel');title('L2(3 animal)');
subplot(2,2,2);histfit(L2A, round(size(L2A,1)/100),'kernel');title('L2 (animal#4)');
subplot(2,2,3);histfit(L2B, round(size(L2B,1)/100),'kernel');title('L2 (animal#5)');
subplot(2,2,4);histfit(L2C, round(size(L2C,1)/100),'kernel');title('L2 (animal#2)');

angle = [angleA;angleB;angleC];
figure(4);subplot(2,2,1);histfit(angle, round(size(angle,1)/100),'kernel');title('angle(3 animal)');
subplot(2,2,2);histfit(angleA, round(size(L1A,1)/100),'kernel');title('angle (animal#4)');
subplot(2,2,3);histfit(angleB, round(size(L1B,1)/100),'kernel');title('angle (animal#5)');
subplot(2,2,4);histfit(angleC, round(size(L1C,1)/100),'kernel');title('angle (animal#2)');

