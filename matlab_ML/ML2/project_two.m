% 2.1
% As each row is variable and column is an observation we have to transpose
% X

X = [ 5 3 0 1 -1 -3 5 0 -4 -4; -2 -1 0 0 1 4 -3 1 5 3;0 1 4 -1 0 5 5 -5 -3 -3; 0 2 3 0 -1 3 3 -7 -2 0; 3 4 -2 1 3 -3 -3 2 0 0]
c = cov(X')
[V,D] = eig(c)

v = diag(D)

u1 = V(:,[end])'
u2 = V(:,[end-1])'

Y = [u1*X;u2*X]'
labels = cellstr( num2str([1:10]') );

plot(Y(:,1),Y(:,2),'o') 
text(Y(:,1),Y(:,2),labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
for i=1:5                         
line([0 u1(i)*10], [0 u2(i)*10], 'Color', 'red')
end

line([0 10], [0 0], 'Color', 'blue')
line([0 0], [0 10], 'Color', 'blue')
line([0 -10], [0 0], 'Color', 'blue')
line([0 0], [0 -10], 'Color', 'blue')

amax=10

axis([-amax,amax,-amax,amax]);
grid on

    

%%

% 2.1
x = cumsum(v)/sum(v)
plot(x)

%%

% 2.2
%A = [-0.9511 0.9511; -1.6435 -1.6435; 2.3655 2.3655; -2.9154 -2.9154; -3.7010 3.7010]
A = [u1;u2]'
U = orth(randn(2,2))
step = 0.001

% This below here is the function we want to maximize
change = 1
prev = 0
vals = []
while abs(change) > 0.000001
%Gradient
G = 4*(A*U).^3
%P = U - U*inv(U'*U)*U'
%U = U + step*P*(A'*G)
%U = (U*U')^(0.5)*U
U = orth(U+step*(A'*G))
AU = A*U
last = sum(sum((A*U).^4))
change = last-prev
prev = last
vals = [vals last]
end

figure
plot(vals)
figure 

AU = [AU(:,2) AU(:,1)]
u1s = AU(:,1)'
u2s = AU(:,2)'
Y = [u1s*X;u2s*X]'

plot(-Y(:,1),Y(:,2),'O') 
text(-Y(:,1),Y(:,2),labels, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')

for i=1:5                         
line([0 u1s(i)*10], [0 u2s(i)*10], 'Color', 'red')
end

line([0 10], [0 0], 'Color', 'blue')
line([0 0], [0 10], 'Color', 'blue')
line([0 -10], [0 0], 'Color', 'blue')
line([0 0], [0 -10], 'Color', 'blue')
                         
amax=10

axis([-amax,amax,-amax,amax]);
grid on
