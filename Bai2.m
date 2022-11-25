clear all;
close all;
tic
folderNameHuanLuyen = ['01MDA','02FVA','03MAB','04MHB','05MVB','06FTB','07FTC','08MLD','09MPD','10MSD','11MVD','12FTD','14FHH','15MMH','16FTH','17MTH','18MNK','19MXK','20MVK','21MTL','22MHL'];
folderNameKiemThu=['23MTL','24FTL','25MLM','27MCM','28MVN','29MHN','30FTN','32MTP','33MHP','34MQP','35MMQ','36MAQ','37MDS','38MDS','39MTS','40MHS','41MVS','42FQT','43MNT','44MTT','45MDV'];
sound =['a','e','i','o','u'];

%% mảng chứa vector đặc trưng cho từng âm của 21 người
vectorDacTrungA=zeros(1,512);
vectorDacTrungE=zeros(1,512);
vectorDacTrungI=zeros(1,512); 
vectorDacTrungO=zeros(1,512);
vectorDacTrungU=zeros(1,512);

fftpoint = 512;
frame_len = 0.03; % độ dài khung
frame_shift = 0.01; % độ dịch khung

for s = 1 : length(folderNameHuanLuyen)/5 % Lấy từng floder
    figure;
    hold on
    signal=folderNameHuanLuyen((s-1)*5+1:5*s);
    title(signal);
    for i=1:5
    hold on;
    % Lấy ra từng âm
    audioName = ['D:\Ki1nam3\CK_XLTHS\Nhom5\Nhom5\NguyenAmKiemThu-16k\' signal '\' sound(i) '.wav'];
    [x,Fs]=audioread(audioName);

    %% cắt ngưỡng hai đầu
    for j=1:length(x)
        if x(j) > 0.3*max(x) % kẻ được cái vạch  bắt đầu 
            numframe1=j;
            break;
        end
    end

    for k=length(x):-1:1 % chạy ngược lại
        if x(k)>0.25*max(x) % kẻ cái vạch cuối cùng , 0.3 lớn quá thì sẽ kẻ cái vạch cuối kẻ vô đoạn tín hiệu có tiếng nói lớn hên phải lùi lại
            numframe2=k;
            break;
        end
    end

    %% chia thành 3 đoạn tín hiệu bằng nhau lấy đoạn tín hiệu ổn định

    khoangchia=ceil((numframe2-numframe1)/3);
  
    data = vectorFFT(x(khoangchia+numframe1:numframe1+2*khoangchia),Fs,0.03,0.01,fftpoint); % mảng chứa m vecto 1024 chiều
    % vạch đầu + khoảng chia => cái vạch xanh đầu : vạch đầu +khoảng chia*2
    % => vạch xanh thứ 2
 
        
    [numframe,numdim] = size(data); % số khung.số chiều(k)

    %% Tính tổng m vecto 1024 chiều
     for j1 = 1 : numdim % số chiều
            sum1 = 0;
            for i1 = 1: numframe % số khung
                sum1 = sum1 + data(i1, j1);
            end
            featured_vector(j1) = sum1 /numframe;% trung bình cộng-> vecto đặc trung của 1 âm của 1 người nói

     end
     featured_vector = featured_vector(1:length(featured_vector)/2);% lấy 1 nửa
     plot(featured_vector);

    %% Tính tổng vector đặc trưng 1 âm của 21 người nói
    if i==1 % âm a
     for m =1:length(featured_vector)
         vectorDacTrungA(m)=vectorDacTrungA(m)+featured_vector(m);
     end
    end
    if i==2
        for m =1:length(featured_vector)
         vectorDacTrungE(m)=vectorDacTrungE(m)+featured_vector(m);
        end
    end
     if i==3
        for m =1:length(featured_vector)
         vectorDacTrungI(m)=vectorDacTrungI(m)+featured_vector(m);
        end
     end
      if i==4
        for m =1:length(featured_vector)
         vectorDacTrungO(m)=vectorDacTrungO(m)+featured_vector(m);
        end
      end
       if i==5
        for m =1:length(featured_vector) % m khung
         vectorDacTrungU(m)=vectorDacTrungU(m)+featured_vector(m);
        end
    end
   
    end
     legend('a','e','i','o','u');
end
    %% Chia trung bình , tính được vector đặc trưng của từng âm
    for m =1:length(featured_vector)
         vectorDacTrungA(m)=vectorDacTrungA(m)/21;
         vectorDacTrungE(m)=vectorDacTrungE(m)/21;
         vectorDacTrungI(m)=vectorDacTrungI(m)/21;
         vectorDacTrungO(m)=vectorDacTrungO(m)/21;
         vectorDacTrungU(m)=vectorDacTrungU(m)/21;
    end
    % featured_vector vector đặc trưng của âm thanh đầu vào

confusionMatrix=zeros(5,5);
for i=1:5
    for ii=1:21
    signal=folderNameKiemThu((ii-1)*5+1:5*ii);
    audioName = ['D:\Ki1nam3\CK_XLTHS\Nhom5\Nhom5\NguyenAmKiemThu-16k\' signal '\' sound(i) '.wav'];
    [x,fs]=audioread(audioName);

     for j=1:length(x)
        if x(j)>0.3*max(x)
            numframe1=j;
            break;
        end
     end
    for k=length(x):-1:1
        if x(k)>0.25*max(x)
            numframe2=k;
            break;
        end
    end
    khoangchia=ceil((numframe2-numframe1)/3);
  data = vectorFFT(x(khoangchia+numframe1:numframe1+2*khoangchia),Fs,0.03,0.01,fftpoint); % mảng chứa m vecto 1024 chiều

    [numframe,numdim] = size(data); % [số khung , số chiều]
    %% Tính tổng m vecto 1024 chiều
     for j1 = 1 : numdim
            sum1 = 0;
            for i1 = 1: numframe
                sum1 = sum1 + data(i1, j1);
            end
            featured_vector(j1) = sum1 /numframe; %trung bình cộng-> vecto đặc trung của 1 âm của 1 người

     end
     featured_vector = featured_vector(1:length(featured_vector)/2);% lay 1 nua

     %% featured_vector vector đặc trưng của âm thanh đầu vào
     d1=distance(featured_vector,vectorDacTrungA); % (cái đang cần tính , dấu vân tay của file  huán luyện)
     d2=distance(featured_vector,vectorDacTrungE);
     d3=distance(featured_vector,vectorDacTrungI);
     d4=distance(featured_vector,vectorDacTrungO);
     d5=distance(featured_vector,vectorDacTrungU);
     arr=[d1,d2,d3,d4,d5];
     [value,index] = min(arr);
    
    

  if(index==i)
          disp(['File ' folderNameKiemThu((s-1)*5+1:5*s) ': Mục tiêu: ' ' ' sound(i) ' - Dự đoán: ' ' ' sound(i)]);
          confusionMatrix(i,i)=confusionMatrix(i,i) +1; % i =1,1 là âm a, đường chéo chính, nhãn đúng
  else
          disp(['File ' folderNameKiemThu((s-1)*5+1:5*s) ': Mục tiêu: ' ' ' sound(i) ' - Dự đoán: ' ' ' sound(index)]);
          confusionMatrix(i,index)=confusionMatrix(i,index)+1; % nhãn sai
  end
    end
end
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
        if(p==5) fprintf('\n'); end;
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
toc;


























