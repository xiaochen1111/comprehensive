load('boost40k.mat');
i=796000:797023;
y=boost40k(i,3)';
%用db1小波对原始信号 进行3层分解并提取系数
[c,l]=wavedec(y,5,'db5');
for i=1:5
    %对分解的第一层到第五层低频系数进行重构
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
