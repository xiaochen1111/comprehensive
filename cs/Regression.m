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
  
%由于X是扁矩阵,需要转置求D0 = min(D) ||Y^T-X^TD^T||  
%这样就是N个未知数，P个方程去求解；  
%每次解得D中的一列，共解M次  
  
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