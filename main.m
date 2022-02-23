% Clear comand window and any 
clc;clear;close all;

%% -------------- read a .wav file -------------------%

[wavData1, Fs1] = audioread("Short_BBCArabic2.wav");
[wavData2, Fs2] = audioread("Short_FM9090.wav");

% Add two column to make it one channel to make a monophonic reciever 
wavData1=wavData1(:, 1)+wavData1(:, 2);
wavData2=wavData2(:, 1)+wavData2(:, 2);

PlotInFreq(wavData1, Fs1, 1, ...
    "Frequency (Hz)", "Amplitude", "Short BBC before interp");

PlotInFreq(wavData2, Fs2, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM before interp");

% Since both signals are not equal length we should pad 
% the small signal to make them equal
if length(wavData1)>length(wavData2)
    wavData2(length(wavData1))=0;
else
    wavData1(length(wavData2))=0;
end

% Use the larger sample to avoid aliasing
if length(Fs1)>length(Fs2)
    Fs=Fs1;
else
    Fs=Fs2;
end


% Increase sampling to make Fs>2Fn to avoid aliasing
wavData1=interp(wavData1, 10);
wavData2=interp(wavData2, 10);

PlotInFreq(wavData1, Fs, 0, ...
    "Frequency (Hz)", "Amplitude", "Short BBC after interp");

PlotInFreq(wavData2, Fs, 0, ...
    "Frequency (Hz)", "Amplitude", "Short FM after interp");


Fs=10*Fs;
%% -------------AM-----------
t=0:1/Fs:((length(wavData1)-1)/Fs);
%t=linspace(0,1/Fs, (length(wavData1)-1)/Fs);
cos1=cos(2*pi*100*10^3*t);           
cos2=cos(2*pi*(100*10^3+50*10^3)*t);           


% Modulation of the carrier
AM1=wavData1.*cos1';
AM2=wavData2.*cos2';

% Add the two signals to send them
AM=AM1+AM2;

% Plot the first modulated signal in freqency domain
PlotInFreq(AM1, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short BBC after Modulation");

% Plot the second modulated signal in freqency domain
PlotInFreq(AM2, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM after Modulation");

PlotInFreq(AM, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM+Short BBC after Modulation");

%% -------------------Reciever-------------------
% RF part to take the signal by bandpass filter which
% Highest freqency is less than Wc+2WIF to avoid image frequency

bpFilt1 = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1',90e3,'CutoffFrequency2',110e3, ...
         'SampleRate',Fs);
bpFilt2 = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1', 127*10^3,'CutoffFrequency2',170*10^3, ...
         'SampleRate',Fs);
%fvtool(bpFilt)
f1=filter(bpFilt1, AM);
f2=filter(bpFilt2, AM);

PlotInFreq(f1, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short BBC at RF");

PlotInFreq(f2, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM at RF");

%% --------------Oscillator---------
WIF=2*pi*25*10^3;
cosIF1=cos((2*pi*100*10^3+WIF)*t);
cosIF2=cos((2*pi*150*10^3+WIF)*t);
AM_Rx1=f1.*cosIF1';
AM_Rx2=f2.*cosIF2';

%PlotInFreq(AM_Rx1, Fs, 1, ...
 %   "Frequency (Hz)", "Amplitude", "Short BBC at WIF");

figure
N=length(AM_Rx1);
% Get fast fourier transform
X=fft(AM_Rx1, N);
% To get positive and negative
n=-N/2:N/2-1;
% Plot the signal 
plot(n*Fs/N, fftshift(abs(X)))

xlim([-Fs Fs])


xlabel("Frequency (Hz)")
ylabel("Amplitude")
title("Short BBC at WIF")

PlotInFreq(AM_Rx2, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM at WIF");


%% -------------The IF stage---------

bpFilt1 = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1',15*10^3,'CutoffFrequency2',35*10^3, ...
         'SampleRate', Fs);

bpFilt2 = designfilt('bandpassfir','FilterOrder',20, ...
         'CutoffFrequency1',10*10^3,'CutoffFrequency2',40*10^3, ...
         'SampleRate', Fs);

f1=filter(bpFilt1, AM_Rx1);
f2=filter(bpFilt2, AM_Rx2);

PlotInFreq(f1, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short BBC at IF");
PlotInFreq(f2, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM at IF");


%% --------Baseband detection

cosIF=cos(WIF*t);
AM_Rx1=f1.*cosIF';
AM_Rx2=f2.*cosIF';

PlotInFreq(AM_Rx1, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short BBC at Baseband");
PlotInFreq(AM_Rx2, Fs, 1, ...
    "Frequency (Hz)", "Amplitude", "Short FM at Baseband");

lpFilt1 = designfilt('lowpassfir','FilterOrder',20, ...
         'CutoffFrequency',7e3, ...
         'SampleRate', Fs);
lpFilt2 = designfilt('lowpassfir','FilterOrder',20, ...
         'CutoffFrequency',10e3, ...
         'SampleRate', Fs);


AM_Rx1=filter(lpFilt1, AM_Rx1);
AM_Rx2=filter(lpFilt2, AM_Rx2);


PlotInFreq(AM_Rx1, Fs, 0, ...
    "Frequency (Hz)", "Amplitude", "Short BBC at Baseband");
PlotInFreq(AM_Rx2, Fs, 0, ...
    "Frequency (Hz)", "Amplitude", "Short FM at Baseband");

%sound(AM_Rx1, Fs)
%sound(AM_Rx2, Fs)
audiowrite('RX_FM.wav',AM_Rx2, Fs)
audiowrite('RX_BBC.wav',AM_Rx1, Fs)


