 %压缩感知重构算法测试    
clear all;close all;clc;    
clc 
clear all
tic
%%   加载数据
load('boostdata.mat');     %加载原始数据
i=15000:1:16023;
y=boostdata(i,2)';
%f=awgn(y,25);             %叠加噪声
f=y;
n=length(f);
a=0.5;                     %压缩率
h = 5;      % setting for wavelet filter
L = log2(n);               % setting for wavelet filter (level)
m = double(int32(a*n));   
%% 构造测量矩阵感知矩阵
 randn('state',7)
 Phi = sqrt(1/m) * randn(m,n);     % 感知矩阵（测量矩阵）   高斯随机矩阵  R＝normrnd(MU,SIGMA,m,n)：sigma 方差
 f2 = (Phi * f')';                 % 通过感知矩阵获得测量值   mx1
% Psi = inv(fft(eye(n,n)));        % 傅里叶正变换，频域稀疏正交基（稀疏表示矩阵）
% %dwtmode('per');
%Psi =inv(dwtmtx( n,'rbio6.8',2 ));       %小波变换 
%Psi=inv(dct(eye(n,n)));
 Psi=inv(gen_dct(1024));
%% 阈值
% ind=find(abs(Psi)<0.01);
% Psi(ind)=0;
%% 恢复矩阵   
% Phi = randn(m,n);                  %测量矩阵为高斯矩阵  
% Phi = orth(Phi')';  
Phi = sqrt(1/m) * randn(m,n);     % 感知矩阵（测量矩阵）   高斯随机矩阵  R＝normrnd(MU,SIGMA,m,n)：sigma 方差
A = Phi* Psi;%传感矩阵    
sigma =0.00003;
e = sigma*randn(m,1);  
f2 = (Phi * f')';   %得到观测向量y    
%% 恢复重构信号x    
tic    
lamda = sigma*sqrt(2*log(n));  
theta =  BPDN_quadprog(f2,A,lamda);  
sig3 = Psi * theta;% x=Psi * theta    
toc    
%% 绘图    
figure;    
plot(sig3,'k');%绘出x的恢复信号    
hold on;    
plot(y,'r');%绘出原信号x    
hold off;    
legend('Recovery','Original')    
%% 评价指标
CR=m/n;
disp(['压缩率',num2str(CR)]);
PRD=sqrt(sum((y'-sig3).^2)./sum(y.^2))*100;
disp(['失真率',num2str(PRD)]);
RMSE=sqrt(sum((y'-sig3).^2)./n)*100;
disp(['均方根误差',num2str(RMSE)]);
SNR=10*(log(sum((y'-mean(y')).^2))./(sum((y'-sig3).^2)));
disp(['信噪比',num2str(SNR)])
toc
disp(['运行时间: ',num2str(toc)]);