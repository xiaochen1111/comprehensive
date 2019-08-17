function [DCT]=DCTdictionary(MM,NN)
% MM,NN    % ����MM��DCT�ֵ��������NN��DCT�ֵ侭����Ƶ�����������
DCT=zeros(MM,NN); 
for k=0:1:MM-1 
     V=sqrt(2 / MM)*cos([0:1:NN-1]'*k*pi/NN); 
     if k>0, V=V-mean(V);
     end
     DCT(:,k+1)=V/norm(V); 
end 
DCT=kron(DCT,DCT); 
