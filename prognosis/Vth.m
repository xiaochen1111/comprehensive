%…Ë÷√≤Œ ˝
T=273+packageTemperature1;
Vgs=supply;
Id=drainCurrent;
drtVt=0.26*exp(-963.13.*(1./T-1./298)).*exp(0.016.*Vgs).*exp(-0.65./Id).*(t./3600/0.4).^(-0.026+1.256.*T./298.*Vgs./20.*Id./9.7)-4.149928692820410e-05;
g=(2.0*1.3-(2+drtVt))/(2.0*1.3);
[gmax,~]=max(g);
[gmin,~]=min(g);
g=(g-gmin)./(gmax-gmin);
iff1=1:762;
tff1=t(iff1);
g=g(iff1);

plot(t,drtVt)
 set(gca,'FontSize',12); set(gcf,'Color','White');  
 xlabel('time /s'); ylabel('Vth /v');  % /Ohm