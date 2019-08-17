function C = gen_dct(n)
alp = [sqrt(1/n) sqrt(2/n)*ones(1,n-1)];
ind = (1:2:(2*n-1))*pi/(2*n);
C = zeros(n,n);
for k = 1:n,
C(k,:) = alp(k)*cos((k-1)*ind);
end