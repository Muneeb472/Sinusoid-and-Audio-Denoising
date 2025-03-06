% Task B: Simulate noise removal using another audio signal

% Load primary audio file (signal of interest)
[audio_signal1, Fs_audio1] = audioread('hmm.wav'); % Replace 'signal1.wav' with your audio file
if size(audio_signal1, 2) > 1
    audio_signal1 = mean(audio_signal1, 2); % Convert stereo to mono
end
t_audio1 = (0:length(audio_signal1)-1) / Fs_audio1; % Time vector for audio

% Load secondary audio file (noise source)
[audio_signal2, Fs_audio2] = audioread('hm2.wav'); % Replace 'signal2.wav' with your noise audio file
if size(audio_signal2, 2) > 1
    audio_signal2 = mean(audio_signal2, 2); % Convert stereo to mono
end

% Resample secondary audio to match the primary audio's sample rate if needed
if Fs_audio1 ~= Fs_audio2
    audio_signal2 = resample(audio_signal2, Fs_audio1, Fs_audio2);
end

t_audio2 = (0:length(audio_signal2)-1) / Fs_audio1; % Time vector for noise audio

% Truncate or zero-pad audio_signal2 to match the length of audio_signal1
if length(audio_signal2) > length(audio_signal1)
    audio_signal2 = audio_signal2(1:length(audio_signal1));
elseif length(audio_signal2) < length(audio_signal1)
    audio_signal2 = [audio_signal2; zeros(length(audio_signal1) - length(audio_signal2), 1)];
end

% Create noisy audio signal by adding the two audio signals
noisy_audio_signal = audio_signal1 + audio_signal2;

% Play original and noisy audio
disp('Playing primary audio (signal of interest)...');
sound(audio_signal1, Fs_audio1); % Uncomment to play the audio
pause(length(audio_signal1)/Fs_audio1 + 1);

disp('Playing secondary audio (noise)...');
sound(audio_signal2, Fs_audio1); % Uncomment to play the audio
pause(length(audio_signal2)/Fs_audio1 + 1);

disp('Playing noisy audio signal...');
sound(noisy_audio_signal, Fs_audio1); % Uncomment to play the audio
pause(length(noisy_audio_signal)/Fs_audio1 + 1);

% Design Filters for audio
lpFilt_audio = designfilt('lowpassfir', 'PassbandFrequency', 1500, ...
    'StopbandFrequency', 2000, 'PassbandRipple', 1, ...
    'SampleRate', Fs_audio1);

bpFilt_audio = designfilt('bandpassfir', 'PassbandFrequency1', 500, ...
    'PassbandFrequency2', 1500, 'StopbandFrequency1', 300, ...
    'StopbandFrequency2', 2000, 'PassbandRipple', 1, ...
    'SampleRate', Fs_audio1);

hpFilt_audio = designfilt('highpassfir', 'PassbandFrequency', 500, ...
    'StopbandFrequency', 300, 'PassbandRipple', 1, ...
    'SampleRate', Fs_audio1);

% Apply Filters to noisy audio
filtered_lp_audio = filtfilt(lpFilt_audio, noisy_audio_signal); % Low-pass filtered audio
filtered_bp_audio = filtfilt(bpFilt_audio, noisy_audio_signal); % Band-pass filtered audio
filtered_hp_audio = filtfilt(hpFilt_audio, noisy_audio_signal); % High-pass filtered audio

% Play filtered audio
disp('Playing low-pass filtered audio...');
sound(filtered_lp_audio, Fs_audio1); % Uncomment to play the audio
pause(length(filtered_lp_audio)/Fs_audio1 + 1);

disp('Playing band-pass filtered audio...');
sound(filtered_bp_audio, Fs_audio1); % Uncomment to play the audio
pause(length(filtered_bp_audio)/Fs_audio1 + 1);

disp('Playing high-pass filtered audio...');
sound(filtered_hp_audio, Fs_audio1); % Uncomment to play the audio
pause(length(filtered_hp_audio)/Fs_audio1 + 1);

% Plot original, noisy, and filtered audio signals
figure;
subplot(5,1,1);
plot(t_audio1, audio_signal1);
title('Primary Audio Signal (Signal of Interest)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(5,1,2);
plot(t_audio1, audio_signal2);
title('Secondary Audio Signal (Noise)');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(5,1,3);
plot(t_audio1, noisy_audio_signal);
title('Noisy Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(5,1,4);
plot(t_audio1, filtered_lp_audio);
title('Low-Pass Filtered Audio');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(5,1,5);
plot(t_audio1, filtered_bp_audio);
title('Band-Pass Filtered Audio');
xlabel('Time (s)');
ylabel('Amplitude');

% Calculate SNR for filtered audio
snr_lp_audio = snr(filtered_lp_audio, filtered_lp_audio - audio_signal1);
snr_bp_audio = snr(filtered_bp_audio, filtered_bp_audio - audio_signal1);
snr_hp_audio = snr(filtered_hp_audio, filtered_hp_audio - audio_signal1);

% Display SNR values
figure;
bar([snr_lp_audio, snr_bp_audio, snr_hp_audio]);
xticks([1, 2, 3]);
xticklabels({'Low-Pass', 'Band-Pass', 'High-Pass'});
title('Signal-to-Noise Ratio (SNR)');
xlabel('Filter Type');
ylabel('SNR (dB)');

% Frequency domain analysis using FFT
N = length(audio_signal1);
f_audio = Fs_audio1*(0:(N/2))/N; % Frequency vector
Y_audio = fftshift(fft(audio_signal1));
Y_noisy_audio = fft(noisy_audio_signal);
Y_filtered_lp_audio = fft(filtered_lp_audio);
Y_filtered_bp_audio = fft(filtered_bp_audio);

figure;
subplot(3,1,1);
plot(f_audio, abs(Y_audio(1:N/2+1)));
title('Frequency Spectrum of Primary Audio Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(3,1,2);
plot(f_audio, abs(Y_noisy_audio(1:N/2+1)));
title('Frequency Spectrum of Noisy Audio Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(3,1,3);
plot(f_audio, abs(Y_filtered_lp_audio(1:N/2+1)));
title('Frequency Spectrum of Low-Pass Filtered Audio');
xlabel('Frequency (Hz)');
ylabel('Amplitude');