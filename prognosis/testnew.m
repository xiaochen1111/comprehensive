%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  函数功能：粒子滤波用于电源寿命预测
 %初始化加载数据
A12Cycle=t;

N=length(A12Cycle);   %循环数

M=1000;  %粒子数目
Future_Cycle=60; %未来趋势
if N>1600
    N=1600;   %滤除大于260的数
end
%过程噪声协方差Q
cita=0.15e-1;
wa=0.000001;wb=0.01;wc=0.1;wd=0.00001;
Q=cita*diag([wa,wb,wc,wd]);
 %驱动矩阵
F=eye(4);
 %观测噪声协方差
R=0.001;
 %a,b,c,d赋初值
a=0.012;b=0.05;c=0.2;d=-0.00088543;
X0=[a,b,c,d]';
 %滤波器初始化
Xpf=zeros(4,N);
Xpf(:,1)=X0;
 %粒子集初始化
Xm=zeros(4,M,N);
for i=1:M
    Xm(:,i,1)=X0+sqrtm(Q)*randn(4,1);
end
 %观测量
Z(1,1:N)=ron1(:,1:N);
 %滤波器预测观测Zm与Xm 对应
Zm=zeros(1,M,N);
 %滤波器滤波后的观测Zpf与Xpf对应
Zpf=zeros(1,N);
 %权值初始化
W=zeros(N,M);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %粒子滤波算法
for k=2:N
  %采样
    for i=1:M
        Xm(:,i,k)=F*Xm(:,i,k-1)+sqrtm(Q)*randn(4,1);
    end
 %重要性权值计算 
    for i=1:M
   %观测预测
        Zm(1,i,k)=feval('hfun',Xm(:,i,k),k);
       %重要性权值
        W(k,i)=exp(-(Z(1,k)-Zm(1,i,k))^2/2/R)+1e-99;
    end
 %权值归一化
    W(k,:)=W(k,:)./sum(W(k,:));
  %重采样调用子函数 
    outIndex = residualR(1:M,W(k,:)');        
     %得到新的样本集，
    Xm(:,:,k)=Xm(:,outIndex,k);
%滤波器的状态更新为：
    Xpf(:,k)=[mean(Xm(1,:,k));mean(Xm(2,:,k));mean(Xm(3,:,k));mean(Xm(4,:,k))];
    %用更新后的状态计算Q（K）
    Zpf(1,k)=feval('hfun',Xpf(:,k),k);
end
%%%%%%%%%%%%%%%%%%%%%%%5
%预测未来电容趋势
%这里选择Xpf(:,start)的点估计，按道理是要对前期得到的值
%做整体处理，由此导致预测不准确，后续的工作请好好处理
%Xpf(:,start),这个矩阵的数据，平滑处理，a,b,c,d
%带入方程预测 未来
start=N-Future_Cycle
for k=start:N
    Zf(1,k-start+1)=feval('hfun',Xpf(:,start),k);%第一种用法中的fhandle是一个函数的handle，
    %x1,x2,…xn是该函数的参数，函数的handle怎么写，看下面的例子 
    Xf(1,k-start+1)=k;
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xreal=[a*ones(1,M);b*ones(1,M);c*ones(1,M);d*ones(1,M)];
figure
subplot(2,2,1);
hold on;box on;
plot(Xpf(1,:),'-r.');plot(Xreal(1,:),'-b.')
legend('粒子滤波后的a','平均值a')
subplot(2,2,2);
hold on;box on;
plot(Xpf(2,:),'-r.');plot(Xreal(2,:),'-b.')
legend('粒子滤波后的b','平均值b')
subplot(2,2,3);
hold on;box on;
plot(Xpf(3,:),'-r.');plot(Xreal(3,:),'-b.')
legend('粒子滤波后的c','平均值c')
subplot(2,2,4);
hold on;box on;
plot(Xpf(4,:),'-r.');plot(Xreal(4,:),'-b.')
legend('粒子滤波后的d','平均值d')
 
%画图
figure
hold on;box on;
plot(t,Z,'b.')   %实验数据，实际测量数据
plot(t,Zpf,'-r.')  %滤波后的数据
iff=165:225;
tff=t(iff);
plot(tff,Zf,'-g.') %预测的电容

%legend('实验测量数据','滤波估计数据')

set(gca,'FontSize',12); set(gcf,'Color','White');  
 xlabel('time /s'); ylabel('log(Ron)');  % /Ohm
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p=polyfit(t2,ron3,1);
%hold on
%yff=polyval(p,t);
%yff1=yff(iff);
%plot(t,yff,'r--','LineWidth',2)
hold on
plot([0,3500],[2.05,2.05],'m--')
plot(2.3,'k')
bar(tff(1),2,'y')
ronf=ron1(iff);%真实值
RMSe0=sqrt(sum((Zpf-ron1).^2)/225) 
RMSe=sqrt(sum((yff1-ronf).^2)/61) ;
RMSe1=sqrt(sum((Zf-ronf).^2)/61) ;

legend('实验测量数据','滤波估计数据','自然预测数据','失效阈值')
%legend('','','最小二乘预测均方根误差为：0.3381','粒子滤波预测均方根误差为：0.2077')
%ylim=get(gca,'Ylim');%获取当前图形纵轴范围



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 函数功能：      参数拟合a,b,c,d
% 非线性函数方程： Q(k)=a*exp(b*k)+c*exp(d*k)
% 其中Q(k),k通过Battery_Capacity文件给定
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 函数名称：电容的观测函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





