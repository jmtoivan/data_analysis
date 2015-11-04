% MATLAB

%
% Generates data
samples = 1000;

% Defining covariance matrix, different data generated with different
% covariance matrices
sigma1 = [1 0.7; 0.2 1];
sigma2 = [1 0.2; 0.4 1];
sigma3 = [1 -0.7; 0.7 1];
sigma4 = [1 0.8; -0.9 1];

% Defining means and standard deviations for the variables
mu = [0 0];
sd = [1 1];
dim1 = size(sigma1, 1);
dim2 = size(sigma2, 1);
dim3 = size(sigma3, 1);
dim4 = size(sigma4, 1);

% Generating data
R1 = chol(sigma1);
R2 = chol(sigma2);
R3 = chol(sigma3);
R4 = chol(sigma4);
dat1 = randn(samples, dim1)*R1;
dat2 = randn(samples, dim2)*R2;
dat3 = randn(samples, dim3)*R3;
dat4 = randn(samples, dim4)*R4;
dat1 = dat1 .* repmat(sd,[samples 1]);
dat1 = dat1 + repmat(mu,[samples 1]);
dat2 = dat2 .* repmat(sd,[samples 1]);
dat2 = dat2 + repmat(mu,[samples 1]);
dat3 = dat3 .* repmat(sd,[samples 1]);
dat3 = dat3 + repmat(mu,[samples 1]);
dat4 = dat4 .* repmat(sd,[samples 1]);
dat4 = dat4 + repmat(mu,[samples 1]);
%
figure
subplot(2,2,1);
scatter(dat1(:,1), dat1(:,2), 'r.')
subplot(2,2,2);
scatter(dat2(:,1), dat2(:,2), 'r.')
subplot(2,2,3);
scatter(dat3(:,1), dat3(:,2), 'r.')
subplot(2,2,4);
scatter(dat4(:,1), dat4(:,2), 'r.')
%
hold on 


% (2) PCA

%
[n m] = size(dat1);
% Standardizing data:
dat_mean1 = mean(dat1);
dat_std1 = std(dat1);
dat11 = (dat1 - repmat(dat_mean1, [n 1])) ./ repmat(dat_std1, [n 1]);
dat_mean3 = mean(dat3);
dat_std3 = std(dat3);
dat33 = (dat3 - repmat(dat_mean3, [n 1])) ./ repmat(dat_std3, [n 1]);

% (3) Applying to two datasets

[V1 D1] = eig(cov(dat11));
[V3 D3] = eig(cov(dat33));
pc11 = V1(:,1);
pc21 = V1(:,2);
pc13 = V3(:,1);
pc23 = V3(:,2);

figure
scatter(dat1(:,1), dat1(:,2), 'r.')
hold on 
plot_arrow(0,0,pc11(1),pc11(2),'linewidth',2,'color',[0 0 0],'facecolor',[1 0 0]);
plot_arrow(0,0,pc21(1),pc21(2),'linewidth',2,'color',[0 0 0],'facecolor',[1 0 0]);
axis equal

figure
scatter(dat3(:,1), dat3(:,2), 'r.')
hold on 
plot_arrow(0,0,pc13(1),pc13(2),'linewidth',2,'color',[0 0 0],'facecolor',[1 0 0]);
plot_arrow(0,0,pc23(1),pc23(2),'linewidth',2,'color',[0 0 0],'facecolor',[1 0 0]);
axis equal

%

% (4) Projecting the data on both PCs, visualize as histograms and compute
% variances

Sigma = [1 0.7; 0.2 1];
R = chol(Sigma);

% Generating data with 1000 samples:
dat = repmat(mu, 1000, 1) + randn(1000, 2)*R;
[n m] = size(dat);
% Standardizing data:
dat_mean = mean(dat);
dat_std = std(dat);
dat2 = (dat - repmat(dat_mean, [n 1])) ./ repmat(dat_std, [n 1]);
[V D] = eig(cov(dat2))
pc1 = V(:,1);
pc2 = V(:,2);
figure
scatter(dat2(:,1), dat2(:,2),'.')

hold on
%plot_arrow(0,0,pc1(1),pc1(2),'linewidth',2,'color',[1 0 0],'facecolor',[1 0 0]);
%plot_arrow(0,0,pc2(1),pc2(2),'linewidth',2,'color',[1 0 0],'facecolor',[1 0 0]);

proj1 = dat2*pc1*pc1';
proj2 = dat2*pc1*pc2';
scatter(proj1(:,1), proj1(:,2),'r.')
scatter(proj2(:,1), proj2(:,2),'r.')
axis equal;


%
% (5)

Sigma = [1 0.7; 0.2 3];
R = chol(Sigma);

% Generating data with 1000 samples:
dat = repmat(mu, 1000, 1) + randn(1000, 2)*R
figure
scatter(dat(:,1), dat(:,2),'.')
[n m] = size(dat);
% Standardizing data:
dat_mean = mean(dat);
dat_std = std(dat);
covariance = cov(dat2)
dat2 = (dat - repmat(dat_mean, [n 1])) ./ repmat(dat_std, [n 1]);
[V D] = eig(cov(dat2))
V
D

% 6

mu = [0 0];
sigma = [1 0.7; 0.2 1];
R = chol(sigma);
dat = repmat(mu, 1000, 1) + randn(1000, 2)*R;
[n, m] = size(dat);
% Standardizing data:
dat_mean = mean(dat);
dat_std = std(dat);
dat2 = (dat - repmat(dat_mean, [n 1])) ./ repmat(dat_std, [n 1]);
%[V, D] = eig(cov(dat2));
[U, S, V] = svd(dat2,0);
pc1 = V(:,1);
pc2 = V(:,2);

dat50 = dat(1:50,:);
proj = dat*(pc1*pc1');
proj50 = dat50*(pc1*pc1');


figure
scatter(dat50(:,1), dat50(:,2),'r.')
hold on 

%plot_arrow(0,0,pc1(1),pc1(2),'linewidth',2,'color',[0 1 0],'facecolor',[0 1 0]);
%plot_arrow(0,0,pc2(1),pc2(2),'linewidth',2,'color',[0 0 0],'facecolor',[0 0 0]);
plot(proj50(:,1), proj50(:,2),'b.')

h = [];
for p = 1:size(dat50,1)
    h(p) = plot([proj50(p,1) dat50(p,1)],[proj50(p,2) dat50(p,2)],'k-');
end
axis equal

% Average reconstruction error:
rerr = [];
for i = 1:size(dat,1)
    rerr(i) = pdist([dat(i); proj(i)], 'euclidean');
end
rerr_ave = mean(rerr)

% Proportion of variance explained:

varx = cumsum(diag(S).^2) / sum(diag(S).^2) * 100;

%
