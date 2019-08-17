set(0,'defaultfigurecolor','w');
%Generate data
param = [3 2];
npa = length(param);
%x = -20:20;
%y = param*[x; ones(1,length(x))]+3*randn(1,length(x));
%data = [x randi(20,1,30);...
   % y randi(20,1,30)];
%figure
data=[t;ron1]
figure
subplot 221
plot(data(1,:),data(2,:),'k*');hold on;
%Ordinary least square mean
p = polyfit(data(1,:),data(2,:),npa-1);
flms = polyval(p,t);
plot(t,flms,'r','linewidth',2);hold on;
title('最小二乘拟合');
%Ransac
Iter = 100;
sigma = 0.1;
Nums = 2;%number select
res = zeros(Iter,npa+1);
for i = 1:Iter
idx = randperm(size(data,2),Nums);
if diff(idx) ==0
    continue;
end
sample = data(:,idx);
pest = polyfit(sample(1,:),sample(2,:),npa-1);%parameter estimate
res(i,1:npa) = pest;
res(i,npa+1) = numel(find(abs(polyval(pest,data(1,:))-data(2,:))<sigma));
end
[~,pos] = max(res(:,npa+1));
pest = res(pos,1:npa);
fransac = polyval(pest,t);
%figure
subplot 222
plot(data(1,:),data(2,:),'k*');hold on;
plot(t,flms,'r','linewidth',2);hold on;
plot(t,fransac,'g','linewidth',2);hold on;
title('RANSAC');