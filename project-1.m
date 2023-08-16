%
% Evrimsel Hesaplamaya Giri�
% Genetik Algoritma ile Bulan�k Sistem Parametre Optimizasyonu
% 
% 18010011056 - UGUR CAN CAKAR
% https://github.com/cancakar35
%
% 18010011067 - BAYRAM YARIM
% https://github.com/BayramYARIM
%

n = 2;
% Fonksiyondan ka� giri� ald���n� burada belirliyoruz. Test olarak(2) al�nd�
% X1 , X2 Giri�ler -> ��k�� Y1
dataset = -5.12 + 10.24*rand(100,n);

% -100 +100 - spehere

% 100 x n(2) bir matris -5.12 <> 5.12 aras�nda rastgele veri seti olu�turuyoruz.

dataset(:,n+1) = arrayfun(@(x) sphere(dataset(x,:)), 1:size(dataset,1));

% n giri�li fonksiyonun sonu� de�erlerini son s�tununa ekleme i�lemini yap�yoruz.

opt = genfisOptions('GridPartition');

% Bulan�k sistemin giri�lerini ayarl�yoruz
% Giri�lerin �yelik fonksiyonlar�n� gauss se�tik.
opt.InputMembershipFunctionType = 'gaussmf';

% 3 Adet �yelik fonksiyonunu ayarlar�yoruz.
opt.NumMembershipFunctions = 3;

% genfis fonksiyonuna giri�leri, ��k��lar� ve ayarlar� veriyoruz. Bulan�k sistem olu�turuluy�r.
fis = genfis(dataset(:,1:end-1),dataset(:,end), opt);

% Olu�turdu�umuz bulan�k sistemin giri�lerinin aral�klar�n� ayarlar�yoruz. 
% for inp=fis.Inputs --> Ugur v2023
for inp=fis.input
    inp.Range = [-5.12 5.12];
end

% Sphere fonksiyonu i�leme sokuyoruz.
function y = sphere(x)
    sumsp = 0;
    for i=1:length(x)
        sumsp = sumsp + x(i)^2;
    end
    y = sumsp;
end