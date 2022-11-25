

function [] = draw(signal)
   TenThumuc=signal;
   arr = ['a','o','u','i','e'];
   for i=1:5
       audioName = ['D:\Ki1nam3\CK_XLTHS\Nhom5\Nhom5\NguyenAmHuanLuyen-16k\' TenThumuc '\' arr(i) '.wav'];
       [x,Fs] = audioread(audioName);
       t = linspace(0,length(x)/Fs, length(x));
       subplot(5,1,i);
       spectrogram(x, 5*10^(-3)*Fs, 2*10^(-3)*Fs, 1024, Fs, 'yaxis' );
       title(arr(i));
   end
end



