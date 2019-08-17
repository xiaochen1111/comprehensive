function [mappedX,V_s,dims]=kpca_train(X,varargin)
% introduction 
% KPCA

% model=kpca_train(x,varargin)

% INPUT
% X    Traning samples(N*d)
%      N: number of samles
%      d: mumber of features

% OUTPUT
% KPCA model

% follow KePeng Qiu
% Dafault Parameters setting
options.sigma=2;  % kernel width
options.dims=3;    % output dimension (dimensionality reduction)
options.type=0;    % 0: dimensionality or feature extraction
options.fd=0;      %0: No fault diagnosis
                   %1:fault diagnosis
if rem(nargin-1,2)
    error('Parameters to kpca_train should be pairs')
end 
numParameters=(nargin-1)/2;
for n=1:numParameters
    Parameters=varargin((n-1)*2+1);
    value=varagin((n-1)*2+2);
    switch Parameters
        case 'type'
            options.type=value;
        case 'dims'
            options.dims=value;
        case 'sigma'
            options.sigma=value;
        case 'fd'
            options.fd=value;
    end
end
X=X';
% number of training samples
L=size(X,1);

% Compute the kernel matrix
K=computeKM(X,X,options.sigma);

% Centralize the kernel matrix
unit=ones(L,L)/L;
K_c=K-unit*K-K*unit+unit*K*unit;

% Solve the eigenvalue problem
[V,D]=eigs(K_c/L);
lambda=diag(D);

% Normalize the eigenvalue
V_s=V./sqrt(L*lambda)';

% Compute the numbers of principal component
dims=options.dims;

% Extract the nonlinear component
mappedX=K_c*V_s(:,dims);

%Store the results
model.mappedX=mappedX;
model.V_s=V_s;

end

%% ×Óº¯Êý
function [K] = computeKM(x,y,sigma)
% DESCRIPTION
% Compute Kernel Matrix
% x: iuput samples (n1??d)
% y: iuput samples (n2??d)
% simga: kernel width
% n1,n2: number of iuput samples
% d: characteristic dimension of the samples
% K: kernelMatrix (n1??n2)
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

sx = sum(x.^2,2);
sy = sum(y.^2,2);
K = exp((bsxfun(@minus,bsxfun(@minus,2*x*y',sx),sy'))/sigma^2);
end


            
