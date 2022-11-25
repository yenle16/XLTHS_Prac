clear all;
close all;
tic;
folderNameKiemThu = ['23MTL','24FTL','25MLM','27MCM','28MVN','29MHN','30FTN','32MTP','33MHP','34MQP','35MMQ','36MAQ','37MDS','38MDS','39MTS','40MHS','41MVS','42FQT','43MNT','44MTT','45MDV'];
sound =  ['a','e','i','o','u'];

k_mean = 4;
num = 13; 
[db_A,db_E,db_I,db_O,db_U] = vectorMFCC(k_mean,num);

%% Phân cụm nguyên âm A
figure
hold on
title('Phân cụm nguyên âm A')
for i=1:k_mean
    plot(db_A(i,:));
end

%% Mỗi nguyên âm 1 cụm
figure
title('Lấy 1 cụm của mỗi nguyên âm')
hold on
plot(db_A(1,:),'r');
plot(db_E(1,:),'g');
plot(db_I(1,:),'b');
plot(db_O(1,:),'m');
plot(db_U(1,:),'k');
legend('A','E','I','O','U');

%% 
freq_vowel = zeros(5,1); % tổng âm
freq_correct = zeros(5,1);  %mảng chứa số lượng cái âm đúng
classify_rate = zeros(5,1); % % tỷ lệ đúng
confusionMatrix = zeros(5,5); % mảng chứa ma trận nhầm lẫn

for j=1:length(sound)
    for s=1 : length(folderNameKiemThu)/5
        path = 'D:\Ki1nam3\CK_XLTHS\Nhom5\Nhom5\NguyenAmKiemThu-16k';
        path = [path folderNameKiemThu((s-1)*5+1:5*s) '\' sound(j) '.wav'];
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

        data = mfcc(y(khoangchia+numframe1:numframe1+2*khoangchia),Fs,'LogEnergy','Ignore','NumCoeffs',num,'Window',hamming(round(Fs*0.03),'periodic'));
       
        [numframe,numdim] = size(data);
        featured_vector = zeros;

         %% Tính tổng m vecto 512 chiều
        for j1 = 1 : numdim
            sum1 = 0;
            for i1 = 1: numframe
                sum1 = sum1 + data(i1, j1);
            end
            featured_vector(j1) = sum1 /numframe; % trung bình cộng-> vecto đặc trung của 1 âm của 1 người
        end
        % featured_vector vector đặc trưng của âm thanh đầu vào
        
        %% Đưa ra quyết định
        min = 9999;
        vowel_idx = 0;
        for ii = 1 : k_mean
            if min > distance(db_A(ii,:),featured_vector) % file huấn luyện, file kiểm thử cái đem đi so khớp 
                min = distance(db_A(ii,:),featured_vector);
                vowel_idx = 1;
            end
            if min > distance(db_E(ii,:),featured_vector)
                min = distance(db_E(ii,:),featured_vector);
                vowel_idx = 2;
            end
            if min > distance(db_I(ii,:),featured_vector)
                min = distance(db_I(ii,:),featured_vector);
                vowel_idx = 3;
            end
            if min > distance(db_O(ii,:),featured_vector)
                min = distance(db_O(ii,:),featured_vector);
                vowel_idx = 4;
            end
            if min > distance(db_U(ii,:),featured_vector)
                min = distance(db_U(ii,:),featured_vector);
                vowel_idx = 5;
            end
        end
        if j==vowel_idx
            freq_correct(j) = freq_correct(j) + 1;
        end

        freq_vowel(j) = freq_vowel(j) + 1;
\
         
        %% 
        confusionMatrix(j,vowel_idx) = confusionMatrix(j,vowel_idx) + 1;
        disp(['File ' folderNameKiemThu((s-1)*5+1:5*s) ': Mục tiêu: ' ' ' sound(j) ' - Dự đoán: ' ' ' sound(vowel_idx)]);
    end
end
%%
for i=1:5
    classify_rate(i) = freq_correct(i)/freq_vowel(i)*100;
end

%% Ma trận nhầm lẫn
Rate = sum(classify_rate)/length(classify_rate);
disp('Ma trận nhầm lẫn :');
disp('--------*-----*-----*-----*-----*-----');
disp('|  File  |  a  |  e  |  i  |  o  |  u  |');
disp('--------*-----*-----*-----*-----*-----');
for l=1:5
    switch l
            case 1
                fprintf('|   a   |');
            case 2
                fprintf('|   e   |');
            case 3
                fprintf('|   i   |');
            case 4
                fprintf('|   o   |');
            case 5
                fprintf('|   u   |');
        end
    for p=1:5
        fprintf('  %0.0f  |',confusionMatrix(l,p));
        if(p==5) fprintf('\n');end;
    end
    disp('--------*-----*-----*-----*-----*-----');
end
% disp(['     ' sound(1) '     ' sound(2) '     ' sound(3) '     ' sound(4) '     ' sound(5) ]);
% disp(confusionMatrix);
%Tinh toan độ chính xác ( % )
RateA=confusionMatrix(1,1)/21*100;
RateE=confusionMatrix(2,2)/21*100;
RateI=confusionMatrix(3,3)/21*100;
RateO=confusionMatrix(4,4)/21*100;
RateU=confusionMatrix(5,5)/21*100;
Tong=0;
for k=1:5
    Tong=Tong+confusionMatrix(k,k);
end
Tong=(Tong/(21*5))*100;
disp(strcat('Độ chính xác :',string(Tong),'%'));
disp(strcat('Độ chính xác âm /a/ :',string(RateA),'%'));
disp(strcat('Độ chính xác âm /e/ :',string(RateE),'%'));
disp(strcat('Độ chính xác âm /i/ :',string(RateI),'%'));
disp(strcat('Độ chính xác âm /o/ :',string(RateO),'%'));
disp(strcat('Độ chính xác âm /u/ :',string(RateU),'%'));

%% Độ chính x
dcx = ['Độ chính xác : ' num2str(Rate) '%'];
disp(dcx);
toc;

%% Xuất vector đặc trưng
for s=1 : length(folderNameKiemThu)/5
    figure
    hold on
    title(folderNameKiemThu((s-1)*5+1:5*s));
    for j=1:length(sound)
        path = 'D:\Ki1nam3\CK_XLTHS\Nhom5\Nhom5\NguyenAmKiemThu-16k\';
        path = [path folderNameKiemThu((s-1)*5+1:5*s) '\' sound(j) '.wav'];
        [y,Fs] = audioread(path);
         %% cắt ngưỡng đầu
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
       
        data = mfcc(y(khoangchia+numframe1:numframe1+2*khoangchia),Fs,'LogEnergy','Ignore','NumCoeffs',num,'Window',hamming(round(Fs*0.03),'periodic'));
        
        [numframe,numdim] = size(data);
        
        featured_vector = zeros;
        for j1 = 1 : numdim
            sum1 = 0;
            for i1 = 1: numframe
                sum1 = sum1 + data(i1, j1);
            end
            featured_vector(j1) = sum1 /numframe;
        end
  
        plot(featured_vector);      
    end
    legend('A','E','I','O','U');
end







