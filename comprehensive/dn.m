%matlab
fs=300;
Time=128;
t=0:1/fs:Time;
f1=1; T1=1/f1;
y1=sin(2*pi*f1*t);
figure;
plot(t,y1);axis([0 4 -3 3]);
title('ԭʼ�����ź�');
y2=y1+randn(1,length(y1));
figure;
plot(t,y2);axis([0 4 -3 3]);
title('�����ź�');

N=Time/T1-3;%�ۼ��в������ֵ���ܳ����ź����з���û����ֵ��ÿ��tt��Ҫ������N-1�����ڣ�׼��չʾ4�����ڣ���N���Ϊ��������-3
T2=T1*fs;
%%
%�����ۼ�ƽ���㷨
A1=linspace(0,4*T1*fs,4*T1*fs-1);%�������������洢���,������������ţ��ʻ������fs
for tt=0:4*T1*fs
    X1=0;
    for i=0:N-1  %����N���ۼ�����ƽ��
        X1=X1+y2(1+tt+i*T2);
    end
     A1(1+tt)=X1/N;
end
figure;
plot(A1);axis([0 1200 -3 3]);grid;
title('�����ۼ��㷨');
%%
%����ʽƽ���㷨
A2=linspace(0,length(y2),length(y2)-1);
Ap1=linspace(0,N,N-1);
for tt=0:4*T1*fs
    Ap1(1)=y2(1+tt);
    for n=2:N
        Ap1(n)=(n-1)/n*Ap1(n-1)+y2(1+tt+(n-1)*T2)/n;
    end
    A2(1+tt)=Ap1(N);
end
figure;
plot(A2);axis([0 1200 -3 3]);grid;
title('����ʽƽ���㷨');
%%
%ָ����Ȩƽ���㷨
A3=linspace(0,length(y2),length(y2)-1);
Ap2=linspace(0,N,N-1);
alpha=30;
beta=(alpha-1)/alpha;
for tt=0:4*T1*fs
     Ap2(1)=y2(1+tt)*(1-beta);
    for n=2:N
        Ap2(n)=beta*Ap2(n-1)+y2(1+tt+(n-1)*T2)*(1-beta);
    end
    A3(1+tt)=Ap2(N);
end
figure;
plot(A3);axis([0 1200 -3 3]);grid;
title('ָ����Ȩƽ���㷨');
%%
%����ƶ�ƽ���㷨
A4=linspace(0,length(y2),length(y2)-1);
for tt=0:4*T1*fs
    if tt<=T2
    A4(1+tt)=(2*y2(1+tt)+y2(1+tt+T2)+y2(1+tt+2*T2))/4;
    elseif T2<tt<=2*T2
        A4(1+tt)=(y2(1+tt-T2)+2*y2(1+tt)+y2(1+tt+T2)+y2(1+tt+2*T2))/5;
        else 
             A4(1+tt)=(y2(1+tt-2*T2)+y2(1+tt-T2)+2*y2(1+tt)+y2(1+tt+T2)+y2(1+tt+2*T2))/6;         
    end
end
figure;
plot(A4);axis([0 1200 -3 3]);grid;
title('����ƶ�ƽ���㷨');  
