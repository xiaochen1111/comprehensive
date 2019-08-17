%软阈值去噪
load('boostdata.mat')
i=15000:16023;
ff=boostdata(i,2)';
b1=awgn(ff,25);             %叠加噪声
%提升小波分解
nx=b1;%一维含噪信号
lsdb4=liftwave('db4');%采用db4小波，得到相应提升方案
els={'p',[-0.125,0.125],0};
lsnew=addlift(lsdb4,els);%添加els到提升方案
xDEC=lwt(nx,lsnew,3);%用lsnew提升小波对信号做3层小波分解
ca1=lwtcoef('ca',xDEC,lsnew,3,1);%ca1、ca2、ca3为小波分解低频系数
ca2=lwtcoef('ca',xDEC,lsnew,3,2);
ca3=lwtcoef('ca',xDEC,lsnew,3,3);
cd1=lwtcoef('cd',xDEC,lsnew,3,1);%cd1、cd2、cd3为小波分解高频系数
cd2=lwtcoef('cd',xDEC,lsnew,3,2);
cd3=lwtcoef('cd',xDEC,lsnew,3,3);
%第一层小波阈值设置
len=length(cd1);%得到一层小波高频系数长度
w=sort(abs(cd1));%对cd1从小至大进行排序

%找cd1系数中值
if rem(len,2)==1%rem函数功能：求余数；判断len/2余数是否为1，确定cd1长度是奇是偶
       v=w((len+1)/2);%长度为奇，取cd1系数中间值
else
       v=(w(len/2)+w(len/2+1))/2;%长度为偶，取中间两个值求平均
end
sigma1=abs(v)/0.6745;%求sigma1
Thr1=sigma1*(2*log(len))^(1/2);%求阈值Thr1

%软阈值处理系数
for ii=1:length(cd1)%for循环
   if(abs(cd1(ii))<=Thr1)%系数绝对值小于阈值，置0
            cd1(ii)=0;
         else if(cd1(ii)>Thr1)%系数绝对值大于阈值
              cd1(ii)=(cd1(ii)-Thr1);%软阈值公式，对绝对值和sgn函数处理后得
             else
                 cd1(ii)=(cd1(ii)+Thr1);
             end
           end
end
%第二层小波阈值设置?????? 
len=length(cd2);
w=sort(abs(cd2));
if rem(len,2)==1
       v=w((len+1)/2);
else
       v=(w(len/2)+w(len/2+1))/2;
end
sigma1=abs(v)/0.6745;
Thr1=1/2*sigma1*(2*log(len))^(1/2);
for ii=1:length(cd2)
       if(abs(cd2(ii))<=Thr1)
             cd2(ii)=0;
       else if(cd2(ii)>Thr1)
                  cd2(ii)=cd2(ii)-Thr1;
           else
                   cd2(ii)=cd2(ii)+Thr1;
end
end
end
%第三层小波阈值设置
len=length(cd3);
w=sort(abs(cd3));
if rem(len,2)==1
 v=w((len+1)/2);
else
 v=(w(len/2)+w(len/2+1))/2;
end
sigma1=abs(v)/0.6745;
Thr1=2/3*sigma1*(2*log(len))^(1/2);
for ii=1:length(cd3)
 if(abs(cd3(ii))<=Thr1)
 cd3(ii)=0;
 else if(cd3(ii)>Thr1)
 cd3(ii)=cd3(ii)-Thr1;
 else
 cd3(ii)=cd3(ii)+Thr1;
 end
 end
end
%小波重建
rec1=ilwt(ca3,cd3,lsnew);%对小波系数进行一层一层重构
rec2=ilwt(rec1,cd2,lsnew);
rec3=ilwt(rec2,cd1,lsnew);%rec3为去噪后信号


plot(rec3);
title('提升小波软阈值消噪后的信号');grid on;
%% 评价指标
% CR=m/n;
% % disp(['压缩率',num2str(CR)]);
PRD=sqrt(sum((ff-rec3).^2)./sum(ff.^2));disp(['失真率',num2str(PRD)]);
RMSE=sqrt(sum((ff-rec3).^2)./n);
disp(['均方根误差',num2str(RMSE)]);
SNR=10*(log(sum((ff-mean(ff)).^2))./(sum((ff-rec3).^2)));
disp(['信噪比',num2str(SNR)])
