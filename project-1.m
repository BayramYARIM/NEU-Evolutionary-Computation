%
% Evrimsel Hesaplamaya Giriþ
% Genetik Algoritma ile Bulanýk Sistem Parametre Optimizasyonu
% 
% 18010011056 - UGUR CAN CAKAR
% https://github.com/cancakar35
%
% 18010011067 - BAYRAM YARIM
% https://github.com/BayramYARIM
%

n = 2;
% Fonksiyondan kaç giriþ aldýðýný burada belirliyoruz. Test olarak(2) alýndý
% X1 , X2 Giriþler -> Çýkýþ Y1
dataset = -5.12 + 10.24*rand(100,n);

% -100 +100 - spehere

% 100 x n(2) bir matris -5.12 <> 5.12 arasýnda rastgele veri seti oluþturuyoruz.

dataset(:,n+1) = arrayfun(@(x) sphere(dataset(x,:)), 1:size(dataset,1));

% n giriþli fonksiyonun sonuç deðerlerini son sütununa ekleme iþlemini yapýyoruz.

opt = genfisOptions('GridPartition');

% Bulanýk sistemin giriþlerini ayarlýyoruz
% Giriþlerin üyelik fonksiyonlarýný gauss seçtik.
opt.InputMembershipFunctionType = 'gaussmf';

% 3 Adet üyelik fonksiyonunu ayarlarýyoruz.
opt.NumMembershipFunctions = 3;

% genfis fonksiyonuna giriþleri, çýkýþlarý ve ayarlarý veriyoruz. Bulanýk sistem oluþturuluyýr.
fis = genfis(dataset(:,1:end-1),dataset(:,end), opt);

% Oluþturduðumuz bulanýk sistemin giriþlerinin aralýklarýný ayarlarýyoruz. 
% for inp=fis.Inputs --> Ugur v2023
for inp=fis.input
    inp.Range = [-5.12 5.12];
end

% Sphere fonksiyonu iþleme sokuyoruz.
function y = sphere(x)
    sumsp = 0;
    for i=1:length(x)
        sumsp = sumsp + x(i)^2;
    end
    y = sumsp;
end