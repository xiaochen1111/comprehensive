%   @Function: Dictionary learning & Regression  
%   Learning Dictionary Given Sparse Representation  
%   @CreateTime: 2013-2-21  
%   @Author: Rachel Zhang  @  http://blog.csdn.net/abcjennifer  
%     
function [ D ] = Regression( Y,X )  
% Y is the sample data to be recovered M*P  
% D is the dictionary M*N  
% X is the sparse coefficient N*P  
% P>N>M  
  
%����X�Ǳ����,��Ҫת����D0 = min(D) ||Y^T-X^TD^T||  
%��������N��δ֪����P������ȥ��⣻  
%ÿ�ν��D�е�һ�У�����M��  
  
Y = Y';  
X = X';  
P = size(Y,1);  
N = size(X,2);  
M = size(Y,2);  
D = zeros(N,M);  
%%  
for i = 1:M  
    y = Y(:,i)
   D(:,i) = regress(y,X);  
end  
D = D';  
end  