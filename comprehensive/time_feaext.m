function [ma,mi,me,Kr,ku,pk]=time_feaext(y_in)
% ʱ��������ȡ���������ֵ����Сֵ��ƽ��ֵ���Ͷ����ӡ��Ͷȡ����ֵ��
% y_in �����ź�
yg=y_in;
for i=16:99:1005
    k=16:99:1005;
    j=i:1:i+99;
    ma(i) = max(yg(j)); %���ֵ
    mi(i)= min(yg(j)); %��Сֵ
    me(i)= mean(yg(j)); %ƽ��ֵ
    Kr(i) = sum(yg(j).^4)/sqrt(sum(yg(j).^2)) ;%�Ͷ�����
    ku(i) = kurtosis(yg(j)); %�Ͷ�
    pk(i)= ma(i)-mi(i); %��-��ֵ
end  
ma=ma(k);
mi=mi(k);
me=me(k);
Kr=Kr(k);
pk=pk(k);
ku=ku(k);
% %% ��1��
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