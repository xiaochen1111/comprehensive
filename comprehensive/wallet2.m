load('boost40k.mat');
i=796000:797023;
y=boost40k(i,3)';
%��db1С����ԭʼ�ź� ����3��ֽⲢ��ȡϵ��
[c,l]=wavedec(y,5,'db5');
for i=1:5
    %�Էֽ�ĵ�һ�㵽������Ƶϵ�������ع�
    B=wrcoef('A',c,l,'db5',6-i);
    subplot(6,1,i+1);
    plot(B);
    ylabel(['A',num2str(6-i)]);
end
figure;
subplot(6,1,1);
plot(y);
ylabel('s');
for i=1:5
    D=wrcoef('D',c,l,'db5',6-i);
    subplot(6,1,i+1);
    plot(D);
     ylabel(['D',num2str(6-i)]);
end
