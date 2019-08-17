%% Compressed Sensing Method for IGBT High-Speed Switching Time On-Line Monitoring
function sig3=compressed(s,no,r)
%% �����������
% s ԭʼ�ź�
% n ����
% r ѹ����
f=s+no';
n=length(f);                   
m = double(int32(r*n)); 
%                    ������������֪����
randn('state',7)
Phi = sqrt(1/m) * randn(m,n);     % ��֪���󣨲�������   ��˹�������  R��normrnd(MU,SIGMA,m,n)��sigma ����
f2 = (Phi * f')';                 % ͨ����֪�����ò���ֵ   mx1
Psi =inv( (fft(eye(n,n))));        % ����Ҷ���任��Ƶ��ϡ����������ϡ���ʾ����
%dwtmode('per');
%Psi =inv(dwtmtx( n,'rbio6.8',2 ));       %С���任 
% Psi=inv(dct(eye(n,n)));
% dwtmode('per');
% wtype = 'sym2';
% N=1024;
% wlev_max = wmaxlev(N,wtype);
% Psi=inv(dwtmtx( N,wtype,8));
%                                ��ֵ
% ind=find(Psi<-0.24); 
% Psi(ind)=0;
%                              �ָ�����
A=Phi*Psi;                         % m*n
%% �ؽ��ź�                  omp �ع�
c=0.01;
for K = 1:220
%       theta = RandOMP(A,f2',K,c);
        theta =CS_OMP(f2,A,K);
    re(K) = norm(f'-real(ifft(full(theta))));
end
theta =CS_OMP(f2,A,find(re==min(min(re))));
% disp(['���ϡ���K=',num2str(find(re==min(min(re))))]);
sig3=real(ifft(full(theta)));
%% ����ָ��    
% CR=m/n;
% disp(['ѹ����',num2str(CR)]);
% PRD=sqrt(sum((s'-sig3).^2)./sum(s'.^2));
% disp(['ʧ����',num2str(PRD)]);
% RMSE=sqrt(sum((s'-sig3).^2)./n);
% disp(['���������',num2str(RMSE)]);
% sigpower=sum(abs(s).^2)/length(s);
% noisepower=sum(abs(sig3'-s).^2)/length(sig3'-s);
% SNR=10*log10(sigpower/noisepower);
% disp(['�����',num2str(SNR)])