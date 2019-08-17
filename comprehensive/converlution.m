%%
% 分析信号的短时能量
i=15000:16023;
y=boostdata2(i,2);for k=47:1:132
u=y(k);
u2=u.*u;
En(k)=sum(u2);
end

k=47:132;
En=En(k);
plot(k,En)%看不出区别
%短时自相关（卷积）
%%
y1=boostdata(i,2);
for k1=59:1:144
u=y1(k1);
u2=u.*u;
En1(k1)=sum(u2);
end
hold on
k1=59:144;
En1=En1(k1);
plot(k1,En1)%看不出区别

%短时自相关（卷积）