va=7661;%约3小时
for k=1:va
 Ron1(k)=measurement.steadyState(k).timeDomain.drainSourceVoltage./measurement.steadyState(k).timeDomain.drainCurrent;
end
for m=1:va
time1(m)=measurement.steadyState(m).timeEpoch;
end
for n=1:va
  packageTemperature1(n)=measurement.steadyState(n).timeDomain.packageTemperature;
end
for p=1:va
  supply(p)=measurement.steadyState(p).timeDomain.supplyVoltage;
end
for q=1:va
  drainCurrent(q)=measurement.steadyState(q).timeDomain.drainCurrent;
end

x=find(Ron1>17|Ron1<1.5);
Ron1(x)=[];
time1(x)=[];
packageTemperature1(x)=[];
drainCurrent(x)=[];
supply(x)=[];
t=[1:15:3377];
t1=[1:15:700];
jff=1:165;
t2=t(jff);

Ron2=Ron1(t);
Ron3=Ron1(t1);
Ron4=Ron1(t2);
packageTemperature1=packageTemperature1(t);
supply=supply(t);
drainCurrent=drainCurrent(t);
ron1=log(Ron2);
ron2=log(Ron3);
ron3=log(Ron4);
ron=diff(Ron2);
Ron2(1)=[];
t(1)=[];
packageTemperature1(1)=[];
ron1(1)=[];
drainCurrent(1)=[];
supply(1)=[];
%f=ron./Ron1;

%[maxr,index]=min(Ron1);
%power=packageTemperature1./Ron1;
Power=supply.*drainCurrent;

Power(1)=[];

Tjunc=packageTemperature1+3.1*supply.*drainCurrent;
%RON=[Ron1,Ron2,Ron3,Ron4];
%Time=[time1,time2,time3,time4];
%PackageTemperature=[packageTemperature,packageTemperature1];
  %plot(Voltage,drainCurrent,'.')
  %title('I-V')
  %figure
  %plot(time1,Voltage,'.')
  %title('t-V')
 
 
 %plot(time1,drainCurrent,'.')
 % title('t-I')
%figure
%plot(t,f,'o')
%title('t-f')
%hold on 
%figure
%plot(t,packageTemperature1,'o')
%title('t-T')
figure
plot([0,4000],[2.05,2.05],'m--')
hold on 
plot(t,ron1,'.')
%hold on 
%plot(t1,ron2,'*')
p=polyfit(t,ron1,1);
hold on
plot(t,polyval(p,t),'r.')
Yff=polyval(p,t);

RMSe=sqrt(sum((polyval(p,t)-ron1).^2)/199) 
legend('失效阈值')


%plot(t,power,'-')
 % title('t-R')
 % figure
%  plot(time1, packageTemperature1)
%plot(Ron1,packageTemperature1,'o')
 %  title('t-T')
 set(gca,'FontSize',12); set(gcf,'Color','White');  
 xlabel('time /s'); ylabel('log(Ron)');  % /Ohm
% legend('True flight position', 'Particle filter estimate');  
tf=(ron1-0.115037463779840)./2.600338531084870e-04;
 