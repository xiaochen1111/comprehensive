function [pcaout,kpcaout,convout,lpctout,emdout]=other_feaext(yin)
% yin Ϊ�����ź�
% pcaout ���ɷַ�����������
% kpcaout �����ɷַ�����������
% convout ���������
% lpctout ����Ԥ��任������
y=yin;
% PCA
k=17:1:1006;
pcain=y(k);
x=reshape(pcain,99,10);   % ��10��ֵдΪ����ÿһ�д���һ������
N=1;
p=gen_pca(x, N, 'svd');
pcaout=p*x;

% KPCA
k=16:1:1005;
pcain=y(k);
x=reshape(pcain,99,10);   % ��10��ֵдΪ����ÿһ�д���һ������
[kpcaout,kpcaout2]=kpca_train(x);

% ���
for i=16:99:1005
    j=i:1:i+99;
    k=16:99:924;
    m=y(j)';
    convout(j)= mean(my_direct_convolution(m,m(end:-1:1)));
end
convout= convout(k);
% ����Ԥ��任

p=8;
ar=lpc(y,p);                            %����Ԥ��任 
nfft=1024;                              % FFT�任����
W2=nfft/2;
m=1:W2+1;                               % ��Ƶ�ʲ����±�ֵ
YFFT=fft(y,nfft);                         % �����ź�y��FFTƵ��
YLPCT=lpcar2ff(ar,W2-1);                   % ����Ԥ��ϵ����Ƶ��
%ת��Ϊ�ֱ�
fftout=20*log10(abs(YFFT(m)));
lpctout=20*log10(abs(YLPCT(m)));

% EMD
emdout=emd(y);

