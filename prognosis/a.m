T = Ron2;
figure(1)
plot(t,T,'y-o')
title('ԭʼ����-�˲�֮��')
hold on;
%% 
%����ƽ���˲�
L = length(T);
N=25;  % ���ڴ�С
k = 0;
m =0 ;
for i = 1:L
    m = m+1;
    if i+N-1 > L
        break
    else
        for j = i:N+i-1
            k = k+1;
            W(k) = T(j) ;
        end
        T1(m) = mean(W);
        k = 0;
    end
end

plot(tff1,T1,'r-')
grid
legend('ԭʼ����','�˲�֮��')
 set(gca,'FontSize',12); set(gcf,'Color','White');  
 xlabel('time /s'); ylabel('Ron /Ohm');  % /Ohm
 figure
%plot(tff1, T1,'r')
 set(gca,'FontSize',12); set(gcf,'Color','White');  
 xlabel('time /s'); ylabel('Ron/Ohm ');  % /Ohm