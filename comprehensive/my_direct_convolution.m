function output_signal=my_direct_convolution(input_signal,impulse_response)
% ×Ô¾í»ýº¯Êý
% Input:
%    input_signal: the input signal
%    impulse_response: the impulse response
% Output:
%    output_signal:the convolution result
N=length(input_signal);%define length of signal
K=length(impulse_response);%define length of impulse response

output_signal=zeros(N+K-1,1);%initializing the output vector

xp=[zeros(K-1,1);input_signal;zeros(K-1,1)];

for i=1:N+K-1

    output_signal(i)=xp(i+K-1:-1:i)'*impulse_response;

end
end
