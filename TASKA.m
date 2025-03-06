% Task A: Simulate noise removal from simple signals

% Parameters
Fs = 1000;            % Sampling frequency
t = 0:1/Fs:1;        % Time vector (1 second)
f = 100;             % Frequency of the sinusoidal signal
pure_signal = sin(2*pi*f*t); % Pure sinusoidal signal

% Generate random noise
noise = randn(size(t)); % Generate random noise

% Create noisy signal
noisy_signal = pure_signal + 0.2 * noise; % Add noise to the pure signal

% Analyze noise characteristics
N = length(noise); % Define N here for noise characteristics
freq_indices = 1:floor(N/2)+1; % Use floor to ensure integer indexing

% Analyze noise characteristics
figure;
subplot(2,1,1);
plot(t, noise);
title('Random Noise Characteristics');
xlabel('Time (s)');
ylabel('Amplitude');


% Plot frequency spectrum of noise
f_noise = Fs*(0:(N/2))/N; % Frequency vector for noise
Y_noise = fft(noise); % FFT of noise
subplot(2,1,2);
plot(f_noise, abs(Y_noise(freq_indices)));
title('Frequency Spectrum of Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Plot original and noisy signals
figure;
subplot(4,1,1); % Corrected subplot indices
plot(t, pure_signal);
title('Pure Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,2); % Corrected subplot indices
plot(t, noisy_signal);
title('Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');


% Design Filters (Corrected High-Pass)
lpFilt = designfilt('lowpassfir', 'PassbandFrequency', 120, ...
                     'StopbandFrequency', 180, 'PassbandRipple', 0.5, ...
                     'StopbandAttenuation', 80, 'SampleRate', Fs);
bpFilt = designfilt('bandpassfir', 'PassbandFrequency1', 90, ...
                     'PassbandFrequency2', 110, 'StopbandFrequency1', 70, ...
                     'StopbandFrequency2', 130, 'PassbandRipple', 0.5, ...
                     'SampleRate', Fs);
hpFilt = designfilt('highpassfir', 'PassbandFrequency', 180, ...
                     'StopbandFrequency', 120, 'PassbandRipple', 0.5, ...
                     'StopbandAttenuation', 80, 'SampleRate', Fs);


% Apply Filters
filtered_lp = filter(lpFilt, noisy_signal); % Low-pass filtered signal
filtered_bp = filter(bpFilt, noisy_signal); % Band-pass filtered signal
filtered_hp = filter(hpFilt, noisy_signal); % High-pass filtered signal

% Plot filtered signals
subplot(4,1,3); % Corrected subplot indices
hold on;
plot(t, filtered_lp, 'r');
plot(t, filtered_bp, 'g');
plot(t, filtered_hp, 'b');
title('Filtered Signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Low-Pass', 'Band-Pass', 'High-Pass');
hold off;

subplot(4,1,4); % Corrected subplot indices
hold on;
plot(t, pure_signal, 'k');
plot(t, filtered_lp, 'r');
plot(t, filtered_bp, 'g');
plot(t, filtered_hp, 'b');
title('Comparison of Original and Filtered Signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Original', 'Low-Pass', 'Band-Pass', 'High-Pass');
hold off;

% Calculate SNR (Corrected Calculation)
snr_lp = 10 * log10(mean(noisy_signal.^2) / mean((noisy_signal - filtered_lp).^2));
snr_bp = 10 * log10(mean(noisy_signal.^2) / mean((noisy_signal - filtered_bp).^2));
snr_hp = 10 * log10(mean(noisy_signal.^2) / mean((noisy_signal - filtered_hp).^2));

% Display SNR values
figure; % Create a new figure for the bar chart
bar([snr_lp, snr_bp, snr_hp]);
xticks([1, 2, 3]);
xticklabels({'Low-Pass', 'Band-Pass', 'High-Pass'});
title('Signal-to-Noise Ratio (SNR)');
xlabel('Filter Type');
ylabel('SNR (dB)');

% Frequency domain analysis of original, noisy, and filtered signals
N = length(pure_signal);
f_filtered = Fs*(0:(N/2))/N; % Frequency vector for filtered signals

Y_puresignal = fft(pure_signal);% FFT of pure signal
Y_noisysignal= fft(noisy_signal);% FFT of noisy signal
Y_lp = fft(filtered_lp); % FFT of low-pass filtered signal
Y_bp = fft(filtered_bp); % FFT of band-pass filtered signal
Y_hp = fft(filtered_hp); % FFT of high-pass filtered signal

% Plot frequency spectrum of filtered signals
figure;
subplot(5,1,1);
plot(f_filtered, abs(Y_puresignal(freq_indices)));
title('Frequency Spectrum of Pure Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(5,1,2);
plot(f_filtered, abs(Y_noisysignal(freq_indices)));
title('Frequency Spectrum of Noisy Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(5,1,3);
plot(f_filtered, abs(Y_lp(freq_indices)));
title('Frequency Spectrum of Low-Pass Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(5,1,4);
plot(f_filtered, abs(Y_bp(freq_indices)));
title('Frequency Spectrum of Band-Pass Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(5,1,5);
plot(f_filtered, abs(Y_hp(freq_indices)));
title('Frequency Spectrum of High-Pass Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');