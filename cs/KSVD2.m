function [A,x]= KSVD(y,codebook_size,errGoal) 
%============================== 
%input parameter 
% y - input signal 
% codebook_size - count of atoms 
%output parameter 
% A - dictionary 
% x - coefficent 
%============================== 
if(size(y,2)<codebook_size) 
   disp('codebook_size is too large or training samples is too small'); 
   return; 
end 
% initialization 
[rows,cols]=size(y);
 r=randperm(cols); 
A=y(:,r(1:codebook_size)); 
A=A./repmat(sqrt(sum(A.^2,1)),rows,1); 
ksvd_iter=10; 
for k=1:ksvd_iter 
 % sparse coding 
        x=OMP(A,y,5.0/6*rows); 
  % update dictionary 
    for m=1:codebook_size 
       mindex=find(x(m,:)); 
       if ~isempty(mindex) 
            mx=x(:,mindex); mx(m,:)=0; my=A*mx; resy=y(:,mindex); 
 
            mE=resy-my; [u,s,v]=svds(mE,1); A(:,m)=u; x(m,mindex)=s*v';
       end 
   end 
end