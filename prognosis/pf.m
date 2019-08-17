x =1.500392101755145; % initial state                      ��ʼ״̬

Q = 0.15e-1; % process noise covariance                         ������������

R = 0.9; % measurement noise covariance                 ������������

tf = 1500; % simulation length                                    ģ�ⳤ��

N = 100000; % number of particles in the particle filter                   �����������е�������

xhat = x;     %xhat=x=0.1

P = 1;

xhatPart = x;    %xhatPart=x=0.1

% Initialize the particle filter. ��ʼ�������˲���xpartֵ�����ڲ�ͬʱ����������

for i = 1 : N

xpart(i) = x + sqrt(P) * randn;   %  randn������׼��̬�ֲ�������������ĺ�����

end      %��ʼ��xpart(i)Ϊ���ɵ�100���������

xArr = [x];    %xArr=x=0.1

xhatPartArr = [xhatPart];   %xhatPartArr = [xhatPart]=0.1

close all;

for k = 1 : tf %tfΪʱ�䳤�ȣ�k�������Ϊʱ�����ϵ�kʱ��

% System simulationϵͳ����

% x����Ϊʱ��k����ʵ״ֵ̬

x = Ron1(k);
%0.5 * x + 25 * x / (1 + x^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn; %״̬����(1)

y =x;
%x^2 / 20 + sqrt(R) * randn;%�۲ⷽ��(2)���۲ⷽ�����ڹ۲�ֵ�ʹ�������֮�佨���ĺ�����ϵʽ��

% Particle filter ����100�����Ӳ�����Ԥ��͹۲�ֵ��ֵ����������ӵ�Ȩ��

for i = 1 : N

xpartminus(i) =(1+0.001)* xpart(i)-0.001*1.500392101755145;
%0.5 * xpart(i) + 25 * xpart(i) / (1 + xpart(i)^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;

ypart = xpartminus(i);

vhat = y - ypart; %�۲��Ԥ��Ĳ�

q(i) = (1 / sqrt(R) / sqrt(2*pi)) * exp(-vhat^2 / 2 / R); %���ݲ�ֵ����100�����Ӷ�Ӧ��Ȩ��

end

% Normalize the likelihood of each a priori estimate.       ÿһ����������������Ŀ�����

qsum = sum(q);

for i = 1 : N

q(i) = q(i) / qsum;%��һ��Ȩ�أ��ϴ��Ȩ�س���qsum��Ϊ�㣬�󲿷ֽ�С��Ȩ�س���qsum��Ϊ��

end

% Resample.         ����ȡ��

for i = 1 : N

u = rand; % uniform random number between 0 and 1      0��1֮��ľ��������

qtempsum = 0;

for j = 1 : N

qtempsum = qtempsum + q(j);

if qtempsum >= u

%�ز����Ե�Ȩ�ؽ����޳���ͬʱ������Ȩ�أ���ֹ�˻��İ취

xpart(i) = xpartminus(j);

break;

end

end

end

% The particle filter estimate is the mean of the particles.      �����˲��Ĺ����ǿ�����ƽ��ֵ

xhatPart = mean(xpart); %���������˲������ľ�ֵ

% Plot the estimated pdf's at a specific time.      �������ض���ʱ����Ƶĸ����ܶȺ���

if k == 20

% Particle filter pdf

pdf = zeros(81,1);

for m = -40 : 40

for i = 1 : N

if (m <= xpart(i)) && (xpart(i) < m+1)

%pdfΪ�����ܶȺ�����������xpart(i)ֵ����[m, m+1)�ϵĴ���

pdf(m+41) = pdf(m+41) + 1;

end

end

end

figure;

m = -40 : 40;

%��ͼ1����k==20ʱ��xpart(i)����ֲ��ܶ�

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

plot(t, xArr, 'b.', t, xhatPartArr, 'g'); %��ͼ2��ӦxArrΪ��ֵ��xhatPartArrΪ�����˲�ֵ

xlabel('time step'); ylabel('state');

legend('True state', 'Particle filter estimate');
