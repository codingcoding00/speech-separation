
[DATA,Fs] = audioread('git.mp3');

% I have converted the audio from stereo to mono for ease of performing
% operations
Length = length(DATA);
 DATA_MONO=DATA(1:Length,1);
 %Length = 450702;
% 
% % For radix 2 FFT, we have to find the next power of 2 greater than the length
% % which is given by the following function.
% 
 NFFT= 2^nextpow2(Length);

% 
% % I save the difference between length and NFFT in a variable DIFF
% 
 
 DIFF = NFFT - Length;

% 
% % Now I do zero padding so that the new array has 2^k elements, where k is
% % a natural number
% 
 
 ZERO = zeros(DIFF,1);
 DATA_Transpose = (DATA_MONO)';
 ZERO_Transpose = (ZERO)' ;
 DATA_NEW_Transpose = [DATA_Transpose ZERO_Transpose];
 DATA_BASE2 = (DATA_NEW_Transpose)' ;

% 
% % Now FFT is performed for the original DATA
 tic
 XFT_DATA = fft(DATA_MONO, NFFT);
 X_ABS_DATA = abs(XFT_DATA);
 toc
% 

 Frequency = ((0:1/NFFT:1-1/NFFT)*Fs);

% % Absolute Value vs Frequency plot
 subplot(2,1,1)
 plot(Frequency, X_ABS_DATA);
 title('Spectrum of original signal');
% 
% 
% 
% % For the modified zero padded data, the FFT is calculated as followed
 tic
 XFT_DATA_BASE2 = fft(DATA_BASE2, NFFT);
 X_ABS_DATA_BASE2 = abs(XFT_DATA_BASE2);
 toc
 hold on

% 
% % Absolute Value vs Frequency plot
% 
subplot(2,1,2)
plot(Frequency, X_ABS_DATA_BASE2)
title('Spectrum with zero padding');
% 
% % Designing a high Pass Filter
d = designfilt('highpassfir', 'PassbandFrequency',2500, 'StopbandFrequency', 2000, 'PassbandRipple', 1, 'StopbandAttenuation', 60, 'SampleRate',44100);
% 

high_Pass_filtered = filtfilt(d, DATA_BASE2);
%plot(high_Pass_filtered);
%sound(high_Pass_filtered,16000);
neww=high_Pass_filtered;
sound(neww,Fs);
%sound(DATA,Fs);
%audiowrite('mod.wav',neww,Fs);
