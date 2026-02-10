function dataFFT = myFFT(signal,sample, ind0, ind1)
% FFTPRO - FFT signal analysis
%   INPUTS  - signal: signal to analyse
%           - sample: Sample period of the data adquisition
%   OUTPUT  - dataFFT: struct with all revelant information
%

signaleval = signal(ind0:ind1);

% signaleval = signaleval - mean(signaleval);        
N = length(signaleval);
Fs = 1/sample;              

Y = fft(signaleval);
P2 = abs(Y)/N;

dataFFT.mag = P2(1:floor(N/2)+1);
dataFFT.mag(2:end-1) = 2*dataFFT.mag(2:end-1);
dataFFT.freq = Fs*(0:floor(N/2))/N;

[dataFFT.magFund, dataFFT.ind_fund] = max(dataFFT.mag);

dataFFT.fund = dataFFT.freq(dataFFT.ind_fund); 
dataFFT.order = dataFFT.freq/dataFFT.fund;
dataFFT.rms = dataFFT.magFund/sqrt(2);
end

