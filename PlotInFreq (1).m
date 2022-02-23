function  PlotInFreq(x, Fs, Flag, ...
        xlab, ylab, tit)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Get the number of point of FFT of the input signal

figure
N=length(x);
% Get fast fourier transform
X=fft(x, N);
% To get positive and negative
n=-N/2:N/2-1;
% Plot the signal 
plot(n*Fs/N, fftshift(abs(X)))

if Flag
    xlim([-Fs/2 Fs/2])
else
    xlim([-Fs/20 Fs/20])
end

xlabel(xlab)
ylabel(ylab)
title(tit)

end

