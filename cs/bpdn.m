 %ѹ����֪�ع��㷨����    
clear all;close all;clc;    
clc 
clear all
tic
%%   ��������
load('boostdata.mat');     %����ԭʼ����
i=15000:1:16023;
y=boostdata(i,2)';
%f=awgn(y,25);             %��������
f=y;
n=length(f);
a=0.5;                     %ѹ����
h = 5;      % setting for wavelet filter
L = log2(n);               % setting for wavelet filter (level)
m = double(int32(a*n));   
%% ������������֪����
 randn('state',7)
 Phi = sqrt(1/m) * randn(m,n);     % ��֪���󣨲�������   ��˹�������  R��normrnd(MU,SIGMA,m,n)��sigma ����
 f2 = (Phi * f')';                 % ͨ����֪�����ò���ֵ   mx1
% Psi = inv(fft(eye(n,n)));        % ����Ҷ���任��Ƶ��ϡ����������ϡ���ʾ����
% %dwtmode('per');
%Psi =inv(dwtmtx( n,'rbio6.8',2 ));       %С���任 
%Psi=inv(dct(eye(n,n)));
 Psi=inv(gen_dct(1024));
%% ��ֵ
% ind=find(abs(Psi)<0.01);
% Psi(ind)=0;
%% �ָ�����   
% Phi = randn(m,n);                  %��������Ϊ��˹����  
% Phi = orth(Phi')';  
Phi = sqrt(1/m) * randn(m,n);     % ��֪���󣨲�������   ��˹�������  R��normrnd(MU,SIGMA,m,n)��sigma ����
A = Phi* Psi;%���о���    
sigma =0.00003;
e = sigma*randn(m,1);  
f2 = (Phi * f')';   %�õ��۲�����y    
%% �ָ��ع��ź�x    
tic    
lamda = sigma*sqrt(2*log(n));  
theta =  BPDN_quadprog(f2,A,lamda);  
sig3 = Psi * theta;% x=Psi * theta    
toc    
%% ��ͼ    
figure;    
plot(sig3,'k');%���x�Ļָ��ź�    
hold on;    
plot(y,'r');%���ԭ�ź�x    
hold off;    
legend('Recovery','Original')    
%% ����ָ��
CR=m/n;
disp(['ѹ����',num2str(CR)]);
PRD=sqrt(sum((y'-sig3).^2)./sum(y.^2))*100;
disp(['ʧ����',num2str(PRD)]);
RMSE=sqrt(sum((y'-sig3).^2)./n)*100;
disp(['���������',num2str(RMSE)]);
SNR=10*(log(sum((y'-mean(y')).^2))./(sum((y'-sig3).^2)));
disp(['�����',num2str(SNR)])
toc
disp(['����ʱ��: ',num2str(toc)]);