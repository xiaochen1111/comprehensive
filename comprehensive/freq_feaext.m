function [dctout,fftout,wtc,fwhtout,hadamaout]=freq_feaext(yin)
% 频域等其他变换域的提取方法：包括dct fft  dwt 沃尔什 哈达玛变换 pca
% yin 输入函数
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
fftout=20*log10(abs(fftout(j))); % 取对数转化为分贝
[fftout]= extrema(fftout);

% dwt
[wtc,wtl]=wavedec(y,3,'db1');
wtcout=20*log10(abs(wtc));
[wtcout]= extrema(wtcout);

% 沃尔什变换
fwhtout=fwht(y);
fwhtout=20*log10(abs(fwhtout));
[fwhtout]= extrema(fwhtout);

% 哈达玛变换
T=1024;
hadamaout=y*hadamard(T);
hadamaout=20*log10(abs(hadamaout));
[hadamaout]= extrema(hadamaout);

