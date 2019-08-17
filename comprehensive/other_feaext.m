function [pcaout,kpcaout,convout,lpctout,emdout]=other_feaext(yin)
% yin 为输入信号
% pcaout 主成分分析法输出结果
% kpcaout 核主成分分析法输出结果
% convout 卷积输出结果
% lpctout 线性预测变换输出结果
y=yin;
% PCA
k=17:1:1006;
pcain=y(k);
x=reshape(pcain,99,10);   % 将10组值写为矩阵，每一列代表一个周期
N=1;
p=gen_pca(x, N, 'svd');
pcaout=p*x;

% KPCA
k=16:1:1005;
pcain=y(k);
x=reshape(pcain,99,10);   % 将10组值写为矩阵，每一列代表一个周期
[kpcaout,kpcaout2]=kpca_train(x);

% 卷积
for i=16:99:1005
    j=i:1:i+99;
    k=16:99:924;
    m=y(j)';
    convout(j)= mean(my_direct_convolution(m,m(end:-1:1)));
end
convout= convout(k);
% 线性预测变换

p=8;
ar=lpc(y,p);                            %线性预测变换 
nfft=1024;                              % FFT变换长度
W2=nfft/2;
m=1:W2+1;                               % 正频率部分下标值
YFFT=fft(y,nfft);                         % 计算信号y的FFT频谱
YLPCT=lpcar2ff(ar,W2-1);                   % 计算预测系数的频谱
%转换为分贝
fftout=20*log10(abs(YFFT(m)));
lpctout=20*log10(abs(YLPCT(m)));

% EMD
emdout=emd(y);

