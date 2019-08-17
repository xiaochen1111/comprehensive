function [DCT]=DCTdictionary(MM,NN)
% MM,NN    % 其中MM是DCT字典的行数，NN是DCT字典经过分频采样后的列数
DCT=zeros(MM,NN); 
for k=0:1:MM-1 
     V=sqrt(2 / MM)*cos([0:1:NN-1]'*k*pi/NN); 
     if k>0, V=V-mean(V);
     end
     DCT(:,k+1)=V/norm(V); 
end 
DCT=kron(DCT,DCT); 
