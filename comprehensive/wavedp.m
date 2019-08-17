%����ֵȥ��
load('boostdata.mat')
i=15000:16023;
ff=boostdata(i,2)';
b1=awgn(ff,25);             %��������
%����С���ֽ�
nx=b1;%һά�����ź�
lsdb4=liftwave('db4');%����db4С�����õ���Ӧ��������
els={'p',[-0.125,0.125],0};
lsnew=addlift(lsdb4,els);%���els����������
xDEC=lwt(nx,lsnew,3);%��lsnew����С�����ź���3��С���ֽ�
ca1=lwtcoef('ca',xDEC,lsnew,3,1);%ca1��ca2��ca3ΪС���ֽ��Ƶϵ��
ca2=lwtcoef('ca',xDEC,lsnew,3,2);
ca3=lwtcoef('ca',xDEC,lsnew,3,3);
cd1=lwtcoef('cd',xDEC,lsnew,3,1);%cd1��cd2��cd3ΪС���ֽ��Ƶϵ��
cd2=lwtcoef('cd',xDEC,lsnew,3,2);
cd3=lwtcoef('cd',xDEC,lsnew,3,3);
%��һ��С����ֵ����
len=length(cd1);%�õ�һ��С����Ƶϵ������
w=sort(abs(cd1));%��cd1��С�����������

%��cd1ϵ����ֵ
if rem(len,2)==1%rem�������ܣ����������ж�len/2�����Ƿ�Ϊ1��ȷ��cd1����������ż
       v=w((len+1)/2);%����Ϊ�棬ȡcd1ϵ���м�ֵ
else
       v=(w(len/2)+w(len/2+1))/2;%����Ϊż��ȡ�м�����ֵ��ƽ��
end
sigma1=abs(v)/0.6745;%��sigma1
Thr1=sigma1*(2*log(len))^(1/2);%����ֵThr1

%����ֵ����ϵ��
for ii=1:length(cd1)%forѭ��
   if(abs(cd1(ii))<=Thr1)%ϵ������ֵС����ֵ����0
            cd1(ii)=0;
         else if(cd1(ii)>Thr1)%ϵ������ֵ������ֵ
              cd1(ii)=(cd1(ii)-Thr1);%����ֵ��ʽ���Ծ���ֵ��sgn����������
             else
                 cd1(ii)=(cd1(ii)+Thr1);
             end
           end
end
%�ڶ���С����ֵ����?????? 
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
%������С����ֵ����
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
%С���ؽ�
rec1=ilwt(ca3,cd3,lsnew);%��С��ϵ������һ��һ���ع�
rec2=ilwt(rec1,cd2,lsnew);
rec3=ilwt(rec2,cd1,lsnew);%rec3Ϊȥ����ź�


plot(rec3);
title('����С������ֵ�������ź�');grid on;
%% ����ָ��
% CR=m/n;
% % disp(['ѹ����',num2str(CR)]);
PRD=sqrt(sum((ff-rec3).^2)./sum(ff.^2));disp(['ʧ����',num2str(PRD)]);
RMSE=sqrt(sum((ff-rec3).^2)./n);
disp(['���������',num2str(RMSE)]);
SNR=10*(log(sum((ff-mean(ff)).^2))./(sum((ff-rec3).^2)));
disp(['�����',num2str(SNR)])
