% MATLAB

digits = load('digits.txt');

% Remove the column average from the images:
image_averages = mean(digits,1);
digits2 = digits - repmat(image_averages,784,1);

% Normalizing to unit norm
digits3 = [];
for i = 1:1000
    digits3(:,i) = digits2(:,i)./norm(digits2(:,i),2);
end

% Remove the row average from the data
pixel_means = mean(digits3,2);
digits4 = digits3 - repmat(pixel_means,1,1000);

%{
% Visualize before and after preprocessing
figure
visual(digits,30)
figure
visual(digits4,30)
%}

% Visualize the mean of each of the 784 random variables
%visual(pixel_means,1)

%
% PCA
[U,S,V] = svd(digits4);

% Proportion of variance explained:
varx = cumsum(diag(S).^2) / sum(diag(S).^2) * 100;
%figure
%plot(1:784,varx)
%title('Proportion of Variance Explained');
%xlabel('Number of Principal Components');
%ylabel('Percentage of Variance Explained');

% Viusalize the first 20 principal components
for i=1:20
subplot(5,4,i)
imshow(mat2gray(reshape(V(:,i),25,40)))
title(num2str(i))
end

figure
visual(digits(:,41:50),4)
%
% Projecting on 1,2,4,8,16,32,64,128 dimensional subspaces
for i = 0:7
    dim = 2^i;
    proj = digits*(V(:,1:dim)*V(:,1:dim)');
    figure
    visual(proj(:,41:50),4)   
    
    % Average reconstruction error
    rerr = [];
    for i = 1:1000
        rerr(i) = mean((digits(:,i)-proj(:,i)).^2); 
    end
    rerr_ave = mean(rerr)
end
%{

% Loading noisy digits
noisy = load('noisyDigits.txt');

% Visualizing before cleaning
%figure

% Cleaning
% First removing the average
noisy2 = [];
for i = 1:100
    noisy2(:,i) = noisy(:,i)./norm(noisy(:,i),2);
end
image_averages2 = mean(noisy2,1);
noisy3 = noisy2 - repmat(image_averages2,784,1);
noisy4 = noisy3 + repmat(pixel_means,1,100);
visual(noisy(:,1:49),7)
figure
visual(noisy4(:,1:49),7)
pc_dim = 100;
% Projecting to PC subspace
proj_n = repmat(noisy4,1,10)*(V(:,1:pc_dim)*V(:,1:pc_dim)');

figure
visual(proj_n(:,1:49),7)
%}