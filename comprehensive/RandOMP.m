function a=RandOMP(D,x,L,c)

% Orthonormal Matching Pursuit with L non-zeros

[n,K]=size(D);
a=[];
residual=x;
indx=zeros(L,1);
for j=1:1:L,
    proj=D'*residual;
    proj=abs(proj);
    proj=exp(min(c*proj.^2,100));
    proj(indx(1:j-1))=0; % no double choice of atoms
    mm=random_choice(proj/sum(proj));
    indx(j)=mm;
    a=pinv(D(:,indx(1:j)))*x;
    residual=x-D(:,indx(1:j))*a;
end;
temp=zeros(K,1);
temp(indx)=a;
a=sparse(temp);

return;
function m=random_choice(prob)

Ref=cumsum(prob);
x=rand(1);
m=find(x-Ref<0,1);

return;