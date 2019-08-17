function [ma,mi,me,Kr,ku,pk]=time_feaext(y_in)
% 时域特征提取：包含最大值、最小值、平均值、峭度因子、峭度、峰峰值。
% y_in 输入信号
yg=y_in;
for i=16:99:1005
    k=16:99:1005;
    j=i:1:i+99;
    ma(i) = max(yg(j)); %最大值
    mi(i)= min(yg(j)); %最小值
    me(i)= mean(yg(j)); %平均值
    Kr(i) = sum(yg(j).^4)/sqrt(sum(yg(j).^2)) ;%峭度因子
    ku(i) = kurtosis(yg(j)); %峭度
    pk(i)= ma(i)-mi(i); %峰-峰值
end  
ma=ma(k);
mi=mi(k);
me=me(k);
Kr=Kr(k);
pk=pk(k);
ku=ku(k);
% %% 归1化
% mab=max(ma);
% mas=min(ma);
% mag=(ma-mas)./(mab-mas);
% ma1b=max(ma1);
% ma1s=min(ma1);
% ma1g=(ma1-ma1s)./(ma1b-ma1s);
% %%%%%%%%%%%%%%%%%
% Krb=max(Kr);
% Krs=min(Kr);
% Krg=(Kr-Krs)./(Krb-Krs);
% Kr1b=max(Kr1);
% Kr1s=min(Kr1);
% Kr1g=(Kr1-Kr1s)./(Kr1b-Kr1s);
% %%%%%%%%%%%%%%%%%
% meb=max(me);
% mes=min(me);
% meg=(me-mes)./(meb-mes);
% me1b=max(me1);
% me1s=min(me1);
% me1g=(me1-me1s)./(me1b-me1s);
% %%%%%%%%%%%%%%%%%
% kub=max(pk);
% kus=min(pk);
% pkg=(pk-kus)./(kub-kus);
% ku1b=max(pk1);
% ku1s=min(pk1);
% pk1g=(pk1-ku1s)./(ku1b-ku1s);