%% Compressed Sensing Method for IGBT High-Speed Switching Time On-Line Monitoring
function sig3=compressed(s,no,r)
%% 输入输出函数
% s 原始信号
% n 噪声
% r 压缩率
f=s+no';
n=length(f);                   
m = double(int32(r*n)); 
%                    构造测量矩阵感知矩阵
randn('state',7)
Phi = sqrt(1/m) * randn(m,n);     % 感知矩阵（测量矩阵）   高斯随机矩阵  R＝normrnd(MU,SIGMA,m,n)：sigma 方差
f2 = (Phi * f')';                 % 通过感知矩阵获得测量值   mx1
Psi =inv( (fft(eye(n,n))));        % 傅里叶正变换，频域稀疏正交基（稀疏表示矩阵）
%dwtmode('per');
%Psi =inv(dwtmtx( n,'rbio6.8',2 ));       %小波变换 
% Psi=inv(dct(eye(n,n)));
% dwtmode('per');
% wtype = 'sym2';
% N=1024;
% wlev_max = wmaxlev(N,wtype);
% Psi=inv(dwtmtx( N,wtype,8));
%                                阈值
% ind=find(Psi<-0.24); 
% Psi(ind)=0;
%                              恢复矩阵
A=Phi*Psi;                         % m*n
%% 重建信号                  omp 重构
c=0.01;
for K = 1:220
%       theta = RandOMP(A,f2',K,c);
        theta =CS_OMP(f2,A,K);
    re(K) = norm(f'-real(ifft(full(theta))));
end
theta =CS_OMP(f2,A,find(re==min(min(re))));
% disp(['最佳稀疏度K=',num2str(find(re==min(min(re))))]);
sig3=real(ifft(full(theta)));
%% 评价指标    
% CR=m/n;
% disp(['压缩率',num2str(CR)]);
% PRD=sqrt(sum((s'-sig3).^2)./sum(s'.^2));
% disp(['失真率',num2str(PRD)]);
% RMSE=sqrt(sum((s'-sig3).^2)./n);
% disp(['均方根误差',num2str(RMSE)]);
% sigpower=sum(abs(s).^2)/length(s);
% noisepower=sum(abs(sig3'-s).^2)/length(sig3'-s);
% SNR=10*log10(sigpower/noisepower);
% disp(['信噪比',num2str(SNR)])