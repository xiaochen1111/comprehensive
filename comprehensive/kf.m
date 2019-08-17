i=15000:16023;
yy =boostdata2(i,2)';%�������е�ԭʼ���ݣ�matlab�Ǵ�1��ʼ��,���ֵҲ���ǲ���ֵ
z=awgn(yy, 30);
lcw_length = length(z);%�󳤶�

%�����ڴ�
xlcw_ = zeros(1, lcw_length);%x���������
xlcw = zeros(1, lcw_length);%x�ĺ������
residual = zeros(1, lcw_length);%�˲�����
p_ = ones(1, lcw_length);%���������
p = ones(1, lcw_length);%���������
k = zeros(1, lcw_length);%����������
%������ʼ��   
%״̬ģ��: x(t) = a x(t-1) + w(t-1)
%����ģ��: z(t) = h x(t) + v(t)
%�����²⣬���������ǲ²�ģ����ڿ������˲��㷨��˵��������ֵ�Ƿ�׼ȷ����ʮ����Ҫ
xlcw(1) =12.9;%��Ҫ��
p(1) = 13;%��Ҫ��
A = 1;
H = 1;%h�Ǽ���������ʵ�ʹ�����h���ܻ�����ʱ����仯��������ٶ�Ϊ������,�������ǿ��Ը�
Q = 5e-4;%5e2;%������ֵ�ĳ�ʼ���ͺܹؼ���   ����Э����  %��Ҫ��e-8
R = 10e-4;%10e-4;%��Ҫ��4e-6

%�������˲�
%����ѭ�����̡�����nsimΪ��ѭ������
for ti = 2 : lcw_length
%Ԥ��
xlcw_(ti) = A * xlcw(ti-1);%x�������������һ��ʱ���ĺ������ֵ��������Ϣ����������û�����룬bΪ0
residual(ti) = z(ti) - H * xlcw_(ti);%z(t)��ʵ�ʲ���ֵ��Ԥ��ֵ֮��Ĳ�Ϊ�˲����̵Ĳ���(����)
p_(ti) = A * A * p(ti-1) + Q;%�������������
%У׼
k(ti) = H * p_(ti)/(H * H * p_(ti) + R);%k(t)Ϊ����������򿨶������ϵ��
p(ti) = p_(ti) * (1 - H * k(ti));%������������
xlcw(ti) = xlcw_(ti) + k(ti) * residual(ti);%���ò������Ϣ���ƶ�x(t)�Ĺ��ƣ�����������ƣ����ֵҲ�������
end

%���濪ʼ��ͼ
xlcw_(1,1)=12.9;
ti = 1: lcw_length;
%����״̬��״̬����
figure;
h3 = plot(ti, z, 'r');
hold on
h2 = plot(ti, xlcw, 'g');
hold on
h1 = plot(ti, xlcw_, 'b');
 set(gca,'FontSize',12); set(gcf,'Color','White');  
 xlabel('time /s'); ylabel('Ron /Ohm');  % /Ohm
hold off
legend([h1(1) h2(1) h3(1)], '�������', '�������', '����ֵ');%��ʾ��ʽ
title('�������, ������ƺͲ���ֵ�ıȽ�');

%axis(gca,[0,lcw_length,30,70]);%�涨��ͼ�ķ�Χ

%��Э����
figure;
h1 = plot(ti, p_, 'b');
hold on;
h2 = plot(ti, p, 'g');
hold off
legend([h1(1) h2(1)], '�������', '�������');
title('������ƺͺ�����Ƶ�Э����');

%axis(gca,[0,lcw_length,0,500]);%�涨��ͼ�ķ�Χ

%����������
figure;
h1 = plot(ti, k, 'b');
legend([h1(1)], '����������');
title('����������');
ylabel('���������� k');
xlabel('By LinChuangwei');