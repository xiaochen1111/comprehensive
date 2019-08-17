function [dctout,fftout,wtc,fwhtout,hadamaout]=freq_feaext(yin)
% Ƶ��������任�����ȡ����������dct fft  dwt �ֶ�ʲ ������任 pca
% yin ���뺯��
y=yin;

% dct 
for i=16:99:1005
j=i:1:i+98;
dctout(j)=dct(y(j));      %*gen_dct(99);
end
dctout=20*log10(abs(dctout(j)));
[dctout]= extrema(dctout);

% fft
for i=16:99:1005
j=i:1:i+98;
fftout(j)=real(fft(y(j)));
end
fftout=20*log10(abs(fftout(j))); % ȡ����ת��Ϊ�ֱ�
[fftout]= extrema(fftout);

% dwt
[wtc,wtl]=wavedec(y,3,'db1');
wtcout=20*log10(abs(wtc));
[wtcout]= extrema(wtcout);

% �ֶ�ʲ�任
fwhtout=fwht(y);
fwhtout=20*log10(abs(fwhtout));
[fwhtout]= extrema(fwhtout);

% ������任
T=1024;
hadamaout=y*hadamard(T);
hadamaout=20*log10(abs(hadamaout));
[hadamaout]= extrema(hadamaout);

