%% Lấy ra được m vector đặc trưng fft 
% y : đoạn nguyên , fs : tần số lấy mẫu, frame_len : độ dài khung,
% frame_shift : độ dịch khung, fft_point: số chiều
function [vectorFFT] = vectorFFT(y,Fs,frame_len,frame_shift,fft_point)
frame_num = floor((size(y,1) - frame_len*Fs)/(frame_shift*Fs)) + 1; %số lượng frame
frame_sample = frame_len*Fs; %số mẫu trong 1 khung
vectorFFT = zeros(frame_num,fft_point);
hm = hamming(frame_sample);
for i=1:frame_num % 1 -> tất cả các khung
    yy = zeros(frame_sample,1);
    frame = y((i-1)*frame_shift*Fs+1:(i-1)*frame_shift*Fs+frame_sample);% duyệt qua tất cả frame
    for j=1:frame_sample  % lấy tất cả mẫu trong khung i
        yy(j) = frame(j)*hm(j); % bỏ hàm làm mịn
    end
    % Áp dụng FFT và sau đó lấy giá trị tuyệt đối trong fftpoint= 1024
    vectorFFT(i,:) = abs(fft(yy,fft_point)); % mảng 2 chiều, chiều 1 là số khung, chiều thứ 2 là số điểm (fft_point)
    
end
end