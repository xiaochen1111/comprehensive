%matlab
fs=300;
Time=128;
t=0:1/fs:Time;
f1=1; T1=1/f1;
y1=sin(2*pi*f1*t);
figure;
plot(t,y1);axis([0 4 -3 3]);
title('原始正弦信号');
y2=y1+randn(1,length(y1));
figure;
plot(t,y2);axis([0 4 -3 3]);
title('加噪信号');

N=Time/T1-3;%累加中参数最大值不能超过信号序列否则没有数值，每个tt都要往后推N-1个周期，准备展示4个周期，故N最大为总周期数-3
T2=T1*fs;
%%
%线性累加平均算法
A1=linspace(0,4*T1*fs,4*T1*fs-1);%创建序列用来存储结果,由于是序列序号，故还需乘上fs
for tt=0:4*T1*fs
    X1=0;
    for i=0:N-1  %进行N次累加用以平均
        X1=X1+y2(1+tt+i*T2);
    end
     A1(1+tt)=X1/N;
end
figure;
plot(A1);axis([0 1200 -3 3]);grid;
title('线性累加算法');
%%
%递推式平均算法
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
title('递推式平均算法');
%%
%指数加权平均算法
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
title('指数加权平均算法');
%%
%五点移动平均算法
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
title('五点移动平均算法');  
