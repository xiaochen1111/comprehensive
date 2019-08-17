Ron_1=T1;
f=(Ron_1(1).*1.2-Ron_1)./(Ron_1(1)*1.2);
[fmax,~]=max(f);
[fmin,~]=min(f);
f=(f-fmin)./(fmax-fmin);
gf=0.7*g+0.3*f; 
h1=plot(tff1,g,'g');
hold on
h2=plot(tff1,f,'-');
hold on
h3=plot(tff1,gf,'r');
legend([h1(1) h2(1) h3(1)], '物理失效模型', '封装失效模型', '综合评价指标');%显示格式
title('失效评价')
set(gca,'FontSize',12); set(gcf,'Color','White');  
xlabel('time /s'); ylabel('可靠性');  % /Ohm
figure
plot(tff1,f)
title('T-f')
set(gca,'FontSize',12); set(gcf,'Color','White');  
xlabel('time /s'); ylabel('可靠性'); 
figure
plot(tff1,g)
title('T-g')
set(gca,'FontSize',12); set(gcf,'Color','White');  
xlabel('time /s'); ylabel('可靠性'); 
x1_1=find(f>0.8&f<1);
x1_2=find(f>0.4&f<=0.8);
x1_3=find(f>0.1&f<=0.4);
x1_4=find(f>0&f<=0.1);
x2_1=find(g>0.8&g<1);
x2_2=find(g>0.4&g<=0.8);
x2_3=find(g>0.1&g<=0.4);
x2_4=find(g>0&g<=0.1);
