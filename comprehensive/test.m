ear all;close all;clc;
N = 2^7;
% 'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
% 'coif1', ... , 'coif5'
% 'sym2', ... , 'sym8', ... ,'sym45'
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'
wtype = 'rbio6.8';
wlev_max = wmaxlev(N,wtype);
if wlev_max == 0
    fprintf('\nThe parameter N and wtype does not match!\n');
end
dwtmode('per');
for wlev = 1:wlev_max
    ww = dwtmtx(N,wtype,wlev);
    x = randn(1,N);
    y1 = (ww*x')';
    [y2,y2l] = wavedec(x,wlev,wtype);
    y_err = sum((y1-y2).*(y1-y2));
    fprintf('wlev = %d: y_err = %f\n',wlev,y_err);
end
