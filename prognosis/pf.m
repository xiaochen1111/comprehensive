x =1.500392101755145; % initial state                      初始状态

Q = 0.15e-1; % process noise covariance                         过程噪声方差

R = 0.9; % measurement noise covariance                 测量噪声方差

tf = 1500; % simulation length                                    模拟长度

N = 100000; % number of particles in the particle filter                   颗粒过滤器中的粒子数

xhat = x;     %xhat=x=0.1

P = 1;

xhatPart = x;    %xhatPart=x=0.1

% Initialize the particle filter. 初始化粒子滤波，xpart值用来在不同时刻生成粒子

for i = 1 : N

xpart(i) = x + sqrt(P) * randn;   %  randn产生标准正态分布的随机数或矩阵的函数。

end      %初始化xpart(i)为生成的100个随机粒子

xArr = [x];    %xArr=x=0.1

xhatPartArr = [xhatPart];   %xhatPartArr = [xhatPart]=0.1

close all;

for k = 1 : tf %tf为时间长度，k可以理解为时间轴上的k时刻

% System simulation系统仿真

% x数据为时刻k的真实状态值

x = Ron1(k);
%0.5 * x + 25 * x / (1 + x^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn; %状态方程(1)

y =x;
%x^2 / 20 + sqrt(R) * randn;%观测方程(2)。观测方程是在观测值和待估参数之间建立的函数关系式。

% Particle filter 生成100个粒子并根据预测和观测值差值计算各个粒子的权重

for i = 1 : N

xpartminus(i) =(1+0.001)* xpart(i)-0.001*1.500392101755145;
%0.5 * xpart(i) + 25 * xpart(i) / (1 + xpart(i)^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;

ypart = xpartminus(i);

vhat = y - ypart; %观测和预测的差

q(i) = (1 / sqrt(R) / sqrt(2*pi)) * exp(-vhat^2 / 2 / R); %根据差值给出100个粒子对应的权重

end

% Normalize the likelihood of each a priori estimate.       每一个先验估计正常化的可能性

qsum = sum(q);

for i = 1 : N

q(i) = q(i) / qsum;%归一化权重，较大的权重除以qsum不为零，大部分较小的权重除以qsum后为零

end

% Resample.         重新取样

for i = 1 : N

u = rand; % uniform random number between 0 and 1      0和1之间的均匀随机数

qtempsum = 0;

for j = 1 : N

qtempsum = qtempsum + q(j);

if qtempsum >= u

%重采样对低权重进行剔除，同时保留高权重，防止退化的办法

xpart(i) = xpartminus(j);

break;

end

end

end

% The particle filter estimate is the mean of the particles.      粒子滤波的估计是颗粒的平均值

xhatPart = mean(xpart); %经过粒子滤波处理后的均值

% Plot the estimated pdf's at a specific time.      绘制在特定的时间估计的概率密度函数

if k == 20

% Particle filter pdf

pdf = zeros(81,1);

for m = -40 : 40

for i = 1 : N

if (m <= xpart(i)) && (xpart(i) < m+1)

%pdf为概率密度函数，这里是xpart(i)值落在[m, m+1)上的次数

pdf(m+41) = pdf(m+41) + 1;

end

end

end

figure;

m = -40 : 40;

%此图1绘制k==20时刻xpart(i)区间分布密度

plot(m, pdf/N , 'r');

hold;

title('Estimated pdf at k=20');

disp(['min, max xpart(i) at k = 20: ', num2str(min(xpart)), ', ', num2str(max(xpart))]);

end

% Save data in arrays for later plotting

xArr = [xArr x];

xhatPartArr = [xhatPartArr xhatPart];

end

t = 0 : tf;

figure;

plot(t, xArr, 'b.', t, xhatPartArr, 'g'); %此图2对应xArr为真值，xhatPartArr为粒子滤波值

xlabel('time step'); ylabel('state');

legend('True state', 'Particle filter estimate');
