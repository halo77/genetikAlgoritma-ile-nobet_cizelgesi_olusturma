% proje , 21.12.2016
% halit temel yalova üniversitesi

%  geceden sonra izinli olmalý doktorlar. kýsýt 1
%  haftanýn gunlerinde en az gece 1 doktor, gunduz 1 dktor olmasý

clear all;clc;


%Degiþkenler

nufus_buy = 50;                                                     %50 nufus buyuklugu belirledik
calisan_sayisi=6;                                                   %kac tane doktorumuz var ise o sayýyý yazýyoruz buraya
birey_uzun = 7 * calisan_sayisi;                                    %gen sayýsý, deðiþken sayýsý
durma_sayisi= 36 * calisan_sayisi;                                  %her birey 36 olmalý, donguden cýkmak için bu sayý onemlidir
mut_oran = 0.01;                                                    %mutasyon oranýmýz
kontrol=0;                                                          % bu deger eger 1 ise dönguden cýkar ve doktor cizelgesi yazdýrýlýr
f = zeros(nufus_buy,1);                                             % fonksiyon degerlerimiz
gunK=0;                                                             %her doktor bir kere gunduz calýsmak zorundadýr
geceK=0;                                                            %her doktor bir kere gece calýsmak zorundadýr


% Baþlangýç nüfusunun oluþturulmasý

nufus = round(2*rand(nufus_buy,birey_uzun)+1);

%KISITLAMALARIMIZ
%tüm doktorlarýn calýsma saatlerini toplayýp yazdýrdýk.
%ilk 7yi toplayýp, ilk doktora, sonraki 7 yi toplayýp, 2.doktora seklinde
%devam ediyor.

toplam=zeros(nufus_buy,calisan_sayisi);

for i=1:nufus_buy
    for j=1:calisan_sayisi
        for d=1:7
                toplam(i,j)= toplam(i,j) + 3*nufus(i,7*j-(d-1));
        end
           
        % 7sinin toplamý 36 olmalý->olmazsa 40 ekle
        if(toplam(i,j)~=36) 
            toplam(i,j)=toplam(i,j)+40;
        end
        
        %geceden sonra gündüz calýsamaz(3den sonra2 olamaz)->olursa40ekle
        for y=1:calisan_sayisi
            
            if(nufus(i,j*7-y)==3 && nufus(i,j*7-(y-1))==2)
               toplam(i,j)=toplam(i,j)+40;
            end
            
            %ardarda 2 gece calýsamaz.(3den sonra 3 olamaz)->olursa 40 ekle
            if(nufus(i,j*7-y)==3 && nufus(i,j*7-(y-1))==3)
               toplam(i,j)=toplam(i,j)+40;
            end
            
        end
       
    end   
    
    %haftanýn gunlerinde en az gece 1 doktor, gunduz 1 dktor olmasý
    for a=1:7
        for k=a:7:birey_uzun           %pazartesi, salý,.. seklinde toplayarak gidecek
            if nufus(i,k)==2
                gunK=1;                %1 tane gunduz olmalý sartý
            elseif nufus(i,k)==3
                geceK=1;               %1 tane gece olmalý sartý
            end 
        end
      for j=1:calisan_sayisi
        if geceK~=1 || gunK~=1        %1 gece ve 1 gunduz yoksa 70 ekle
            toplam(i,j)=toplam(i,j)+70;
        end
      end
      geceK=0;
      gunK=0;
    end
end



% Amaç fonksiyon deðerinin bulunmasý
%f = toplam(:,1) + toplam(:,2) + toplam(:,3) + toplam(:,4) + toplam(:,5) + toplam(:,6)+ toplam(:,7);

for i=1:nufus_buy
    for j=1:calisan_sayisi
        f(i,1)= f(i,1)+toplam(i,j);
    end
end




%kontrol 1 degerini alana kadar doner
%kontrol 1 olmasý demek kosullarýmýzý saglýyor olmasý demektir

while kontrol==0   

    %Elit elemaný ayarlamak için en dusuk degeri tutmak için 
    [fsira findis] = min(f);
    elitist = nufus(findis,:);
    elitist_f = min(f);

    % Seçim iþlemi için sýra tabanlý uygunluk atama
    [sira indis] = sort(f);
    
    %temp dediðimiz, 1 den nufus_buy kadar sayidir.
    for i=1:nufus_buy
        temp(i,1)=i;
    end
    
    %uygunluk degeri atama, tempi cýkarýyoruz. 1,2,3...
    
    uygunluk(indis(:)) = (nufus_buy+1-temp)*0.1;
    uygunluk = uygunluk';
    top_uyg = sum(uygunluk);
    
    %rulet için dilimler olusturuyoruz.
    secim = uygunluk(:)/top_uyg;
    [ssira sindis] = sort(secim,'descend');

    
    % Rulet Tekerleði Yöntemi
    for i=1:nufus_buy
        sayi = rand(1);
        dilim = 0; temp = 0;
        while(sayi>temp)
            dilim = dilim+1;
            temp = temp + secim(dilim);
        end
        rulet(i,1) = sindis(dilim);
    end
    
    %ruletteki dilimlerin yarýsýný e1 e, diðer yarýsý e2 ye atandý.
    e1 = rulet(1:nufus_buy/2,1);
    e2 = rulet(nufus_buy/2+1:nufus_buy,1);
    
    ebeveyn1 = nufus(e1,:);
    ebeveyn2 = nufus(e2,:);
    cocuk1=zeros(nufus_buy/2,birey_uzun);
    cocuk2=zeros(nufus_buy/2,birey_uzun);
    
    % ÇAPRAZLAMA YAPMA
    for i=1:nufus_buy/2
        cap=round(birey_uzun-1*rand(1));%caprazlama noktasý secildi.
        cocuk1(i,1:cap) = ebeveyn1(i,1:cap);
        cocuk1(i,cap+1:birey_uzun) = ebeveyn2(i,cap+1:birey_uzun);
        cocuk2(i,1:cap) = ebeveyn2(i,1:cap);
        cocuk2(i,cap+1:birey_uzun) = ebeveyn1(i,cap+1:birey_uzun);
    end
    
    
    %yeni bireyler artýk nufusumuz oldu.
    nufus = cat(1,cocuk1,cocuk2);


    
    % MUTASYON
    for i=1:nufus_buy
        for j=1:birey_uzun
            temp = rand(1);
            if temp<mut_oran 
                nufus(i,j) = round(2*rand(1)+1); 
            end
        end
    end

    
    
    %%tekrar nufusun bulunmasý
    for i=1:nufus_buy
        for j=1:calisan_sayisi
            toplam(i,j)=sum(3*(nufus(i,j*7-6)+nufus(i,j*7-5)+nufus(i,j*7-4)+nufus(i,j*7-3)+nufus(i,j*7-2)+nufus(i,j*7-1)+nufus(i,j*7)));
            %7sinin toplamý 36 olmalý->olmazsa 40 ekle
            if(toplam(i,j)~=36) 
                toplam(i,j)=toplam(i,j)+40;
            end
            %geceden sonra gündüz calýsamaz(3den sonra2 olamaz)->olursa40ekle
            if((nufus(i,j*7-6)==3 && nufus(i,j*7-5)==2)||(nufus(i,j*7-5)==3 && nufus(i,j*7-4)==2)||(nufus(i,j*7-4)==3 && nufus(i,j*7-3)==2)||(nufus(i,j*7-3)==3 && nufus(i,j*7-2)==2)||(nufus(i,j*7-2)==3 && nufus(i,j*7-1)==2)||(nufus(i,j*7-1)==3 && nufus(i,j*7)==2))
                toplam(i,j)=toplam(i,j)+40;
            end
            %ardarda 2 gece calýsamaz.(3den sonra 3 olamaz)->olursa 40 ekle
            if((nufus(i,j*7-6)==3 && nufus(i,j*7-5)==3)||(nufus(i,j*7-5)==3 && nufus(i,j*7-4)==3)||(nufus(i,j*7-4)==3 && nufus(i,j*7-3)==3)||(nufus(i,j*7-3)==3 && nufus(i,j*7-2)==3)||(nufus(i,j*7-2)==3 && nufus(i,j*7-1)==3)||(nufus(i,j*7-1)==3 && nufus(i,j*7)==3))
                toplam(i,j)=toplam(i,j)+40;
            end  
        end
        %haftanýn gunlerinde en az gece 1 doktor, gunduz 1 dktor olmasý
        for a=1:7
            for k=a:7:birey_uzun
                if nufus(i,k)==2
                    gunK=1;
                elseif nufus(i,k)==3
                    geceK=1;
                end 
            end
            for j=1:calisan_sayisi
                if geceK~=1 || gunK~=1
                    toplam(i,j)=toplam(i,j)+70;
                end
            end
            geceK=0;
            gunK=0;
        end
        
        %yazdýrma
                                    % yeni amaç fonksiyon deðerinin bulunmasý
                                    %f(i,1) = toplam(i,1) + toplam(i,2) + toplam(i,3) + toplam(i,4) + toplam(i,5) + toplam(i,6)+ toplam(i,7);
        f(:)=0;                     %sýfýrlamazsak degerler cok buyuyo.
        for a=1:nufus_buy
            for j=1:calisan_sayisi
                f(a,1)= f(a,1)+toplam(a,j);
            end
        end
        if f(i,1)==durma_sayisi
            kontrol=1;%while dan cýkýp, programý durdurmak için.
            
            %ilkDoktor=nufus(i,1:7)
            %ikinciDoktor=nufus(i,8:14)
            %ucuncuDoktor=nufus(i,15:21)
            %dorduncuDoktor=nufus(i,22:28)
            %besinciDoktor=nufus(i,29:35)
            %altinciDoktor=nufus(i,36:42)
            %yediDoktor=nufus(i,43:49)
            %yazdirma
            
            sayi1=1;
            sayi2=7;
            for z=1:calisan_sayisi
                    
                    doktor(z,1:7)=nufus(i,sayi1:sayi2);
                    sayi1=sayi1+7;
                    sayi2=sayi2+7; 
            end
            
           
            
        end
        
        
    end
   
    
    [fsira findis] = max(f);
    nufus(findis,:) = elitist(1,:);
    f(findis) = elitist_f;
end%while dongusu bitti.


   doktor
disp('1:Izin')
disp('2:Gunduz')
disp('3:Gece')