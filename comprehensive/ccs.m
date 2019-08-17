%   �ó���������֤ѹ����֪���ۣ�������L1��С��������OMP��⣩
clc 
clear all
load('boostdata.mat')
load('boost40k.mat')
%% �����ź�
choice_transform =0;      % ѡ����������1Ϊѡ��DCT�任��0Ϊѡ��FFT�任
choice_Phi = 0           %ѡ���������1Ϊ���ֹ��������0Ϊ��˹�������
%-----------------------�������Ǻ�������Ƶ���DCT����ɢ�ź�--------------------------
% i=15000:16023;  
i=796000:797023;
y=boost40k(i,2)';
% f =awgn(y,25); %����������
w = 0.005*randn(1024,1);
f=y+w';
% f=y;
%-------------------------------�źŽ�������-----------------------
n = length(f);
a = 0.38;            %    ȡԭ�źŵ� a%
m = double(int32(a*n));
%%
switch choice_transform
    case 1
        ft = dct(f);
        disp('ft = dct(f)')
    case 0
        ft = fft(f);
        disp('ft = fft(f)')
end
disp(['�ź�ϡ��ȣ�',num2str(length(find((abs(ft))>0.1)))])
switch choice_transform
    case 1
        plot(ft)
        disp('plot(ft)')
    case 0
        plot(abs(ft));
        disp('plot(abs(ft))')
end
xlabel('Frequency (Hz)'); 
%% ������֪�����ϡ���ʾ����
%--------------------------���ø�֪�������ɲ���ֵ---------------------
switch choice_Phi
    case 1
        Phi = PartHadamardMtx(m,n);       % ��֪���󣨲�������    ���ֹ��������
    case 0
        randn('state',7)
        Phi = sqrt(1/m) * randn(m,n);     % ��֪���󣨲�������   ��˹�������
end
% Phi =  randn(m,n);    %randn ���ɱ�׼��̬�ֲ���α���������ֵΪ0������Ϊ1��
% Phi = rand(m,n);    % rand ���ɾ��ȷֲ���α��������ֲ��ڣ�0~1��֮��
f2 = (Phi * f')';                 % ͨ����֪�����ò���ֵ
switch choice_transform
    case 1
        Psi =inv(dct(eye(n,n)));            %��ɢ���ұ任������ �������дΪPsi = dctmtx(n);
        disp('Psi = dct(eye(n,n));')
    case 0
        Psi = inv(fft(eye(n,n)));     % ����Ҷ���任��Ƶ��ϡ����������ϡ���ʾ����
        disp('Psi = inv(fft(eye(n,n)));')
end
%% ��ֵ
%  ind=find(abs(Psi)<0.01&abs(Psi)>-0.01);
%  Psi(ind)=0;
A = Phi * Psi;                    % �ָ����� A = Phi * Psi
%%             �ؽ��ź�
%---------------------ʹ��CVX�������L1������Сֵ-----------------
%cvx_begin;
%variable x(n) complex;
% variable x(n) ;
%minimize( norm(x,1) );
%subject to
%A*x ==f2' ;
%cvx_end;
%figure(2);
%subplot(2,2,1)
%switch choice_transform
%  case 1
%        plot(real(x));
%        disp('plot(real(x))')
%    case 0
%        plot(abs(x));
%       disp(' plot(abs(x))')
%end
%title('Using L1 Norm��Frequency Domain��');
%ylabel('DCT(f(t))'); 
%xlabel('Frequency (Hz)');

%switch choice_transform
%    case 1
%    sig = dct(real(x));
%   disp('sig = dct(real(x))')
%    case 0
%   sig = real(ifft(full(x)));
%      disp(' sig = real(ifft(full(x)))')
%end
%subplot(2,2,2);
%plot(f)
%hold on;
%plot(sig);
%title('Using L1 Norm (Time Domain)');
%ylabel('f(t)'); xlabel('Time (s)');
%legend('Original','Recovery')
%%
%-----------------------------ʹ��OMP�㷨�ؽ�--------------------------
for K = 1:220
    theta = CS_OMP(f2,A,K);
    %     figure;plot(dct(theta));title(['K=',num2str(K)])
    switch choice_transform
        case 1
            re(K) = norm(f'-(idct(theta)));
        case 0
            re(K) = norm(f'-real(ifft(full(theta))));
    end
end
theta = CS_OMP(f2,A,find(re==min(min(re))));
disp(['���ϡ���K=',num2str(find(re==min(min(re))))]);
% theta = CS_OMP(f2,A,10);
figure(1)
subplot(2,2,3);
switch choice_transform
    case 1
        plot(theta);
        disp('plot(theta)')
    case 0
        plot(abs(theta));
        disp('plot(abs(theta))')
end
title(['Using OMP(Frequence Domain)  K=',num2str(find(re==min(min(re))))])
switch choice_transform
    case 1
        sig3 = idct(theta);
        disp('sig2 = dct(theta)')
    case 0
        sig3 = real(ifft(full(theta)));
        disp('sig2 = real(ifft(full(theta)))')
end
%% ----4.�ؽ���������--------------
disp('abs_err=');
disp(norm(sig3 - y) );
disp('relative_erro=');
disp( norm(sig3 - y) / norm(y) );
SNR = 20 * log10( norm(y)/norm(sig3 - y) );
%% ����ָ��
CR=m/n
disp(['ѹ����',num2str(CR)]);
PRD=sqrt(sum((y'-sig3).^2)./sum(y.^2));
disp(['ʧ����',num2str(PRD)]);
RMSE=sqrt(sum((y'-sig3).^2)./n);
disp(['���������',num2str(RMSE)]);
SNR=10*(log(sum((y'-mean(y')).^2))./(sum((y'-sig3).^2)));
disp(['�����',num2str(SNR)])
