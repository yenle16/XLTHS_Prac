function [k_mean_vecto_A,k_mean_vecto_E,k_mean_vecto_I,k_mean_vecto_O,k_mean_vecto_U] = vectorMFCC(k_mean,num)
folderNameHuanLuyen = ['01MDA','02FVA','03MAB','04MHB','05MVB','06FTB','07FTC','08MLD','09MPD','10MSD','11MVD','12FTD','14FHH','15MMH','16FTH','17MTH','18MNK','19MXK','20MVK','21MTL','22MHL'];
vowel =  ['a','e','i','o','u'];

k_mean_vecto_A = zeros(k_mean,num); % mảng 2 chiều chứa số cụm và số chiều của 1 âm
k_mean_vecto_E = zeros(k_mean,num);
k_mean_vecto_I = zeros(k_mean,num);
k_mean_vecto_O = zeros(k_mean,num);
k_mean_vecto_U = zeros(k_mean,num);

for j=1:length(vowel)
    vecto = [];
    for k=1 : length(folderNameHuanLuyen)/5 % lấy ra được 1 file
        path = 'D:\Ki1nam3\CK_XLTHS\Nhom5\Nhom5\NguyenAmHuanLuyen-16k'; 
        path = [path folderNameHuanLuyen((k-1)*5+1:5*k) '\' vowel(j) '.wav']; % Lấy ra từng âm của 1 dile
        [y,Fs] = audioread(path);
         
        %% cắt ngưỡng đầu phân biệt nguyên âm và khoảng lặng
        for m=1:length(y)
            if y(m)>0.3*max(y)
               numframe1=m;
               break;
            end

         end

         for n=length(y):-1:1
            if y(n)>0.25*max(y)
               numframe2=n;
               break;
            end
         end

    %% chia thành 3 đoạn tín hiệu bằng nhau lấy đoạn tín hiệu ổn định
        khoangchia=ceil((numframe2-numframe1)/3);

        coeffs = mfcc(y(khoangchia+numframe1:numframe1+2*khoangchia),Fs,'LogEnergy','Ignore','NumCoeffs',num,'Window',hamming(round(Fs*0.03),'periodic'));
       % Ignore: hàm không tính toán hoặc trả về năng lượng 
        vecto= [vecto;coeffs]; % vector là danh sách các vector cần phân cụm
    end

    xx = ones(k_mean,num); % mảng chứa vị trí bắt đầu của cụm trung tâm, C là mảng chứa kết quả trả về
    %% Tìm được vectror trọng tâm trong 1 cụm của từng âm
    [idx,C] = kmeans(vecto,k_mean,'Start',xx);
    switch j
        case 1
            k_mean_vecto_A = C;
        case 2
            k_mean_vecto_E = C;
        case 3
            k_mean_vecto_I = C;
        case 4
            k_mean_vecto_O = C;
        case 5
            k_mean_vecto_U = C;
    end
end
end