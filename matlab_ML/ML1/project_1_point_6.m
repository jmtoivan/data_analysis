% MATLAB

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

% What is the relation between average reconstruction error and proportion
% of variance explained