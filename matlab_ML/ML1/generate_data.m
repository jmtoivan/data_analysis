% MATLAB
% generates data

samples = 1000;
sigma = [1 0.7; 0.2 1];
mu = [0 0];
sd = [1 1];
dim = size(sigma, 1);
R = chol(sigma);
dat = randn(samples, dim)*R;
dat = dat .* repmat(sd,[samples 1]);
dat = dat + repmat(mu,[samples 1]);
figure
scatter(dat(:,1), dat(:,2), 'r.')
hold on 
[U,S,V] = svd(dat);
pc1 = V(:,1);
pc2 = V(:,2);
plot_arrow(0,0,pc1(1),pc1(2),'linewidth',2,'color',[0 0 0],'facecolor',[1 0 0]);
plot_arrow(0,0,pc2(1),pc2(2),'linewidth',2,'color',[0 0 0],'facecolor',[1 0 0]);
axis equal
pc1
pc2

proj1 = dat*pc1*pc1';
proj2 = dat*pc2*pc2';

scatter(proj1(:,1),proj1(:,2),'b.')
scatter(proj2(:,1),proj2(:,2),'b.')

figure
projx = proj1*[1 0; 0 0];
variance = var(projx(:,1))
hist(projx(:,1), 20);

figure
projx = proj2*[1 0; 0 0];
variance = var(projx(:,1))
hist(projx(:,1), 20);


