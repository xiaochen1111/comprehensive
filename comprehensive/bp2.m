%% ����
clc 
clear all
sig=0.2;
%%   ��������
load('boostdata.mat');     %����ԭʼ����
i=15000:1:16023;
y=boostdata(i,2)';
n=length(y);
a=0.5;                     %ѹ����
m = double(int32(a*n));   
w = sig*randn(m,1);
yn =awgn(y,25);                %y + w;           %��������f=awgn(y,25);
% randn('state',7)
% w=20*randn(1024,1);
% f=y+w';

h = 5;      % setting for wavelet filter
L = log2(n);               % setting for wavelet filter (level)
lam=0.35;
itrs=34;
%% ��������
rand('state',15)
q = randperm(n);
Dn = gen_dct(n);
Psi1 = Dn';
% Reconstruction of signal x by l1-minimization
A = Psi1(q(1:m),:);
tmax = 1/max(eig(A*A'));
tt = 0.95*tmax;
thk = zeros(n,1);
alp = lam*tt;
%% �ع��ź�
for i = 1:itrs
ck = thk - 2*tt*A'*(A*thk-yn);
thk = (max(abs(ck)-alp,0)).*sign(ck);
end
xh = Psi1*thk;
