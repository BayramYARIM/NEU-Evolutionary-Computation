%
% Evrimsel Hesaplamaya Giriş
% Genetik Algoritma ile Bulanık Sistem Parametre Optimizasyonu
% 
% 18010011056 - UGUR CAN CAKAR
% https://github.com/cancakar35
%
% 18010011067 - BAYRAM YARIM
% https://github.com/BayramYARIM
%

n = 2;
dataset = -5.12 + 10.24*rand(100,n);

dataset(:,n+1) = arrayfun(@(x) sphere(dataset(x,:)), 1:size(dataset,1));

opt = genfisOptions('GridPartition');
opt.InputMembershipFunctionType = 'gaussmf';
opt.NumMembershipFunctions = 3;
fis = genfis(dataset(:,1:end-1),dataset(:,end), opt);
for inp=fis.input
    inp.Range = [-5.12 5.12];
end

len_inp_params = length(fis.Inputs) * opt.NumMembershipFunctions * 2;
len_out_params = length(fis.output.mf) * (n+1);
total_params = len_inp_params + len_out_params;
len_pop = 5;

fitness = zeros(len_pop,1);

pop = -5.12 + 10.24*rand(len_pop, total_params);
pop = pop + 0.0001;

for i=1:len_pop
    prm = 1;
    for inp=1:n
        for j=1:length(fis.input(inp).mf)
            fis.input(inp).mf(j).params(1) = abs(pop(i,prm));
            fis.input(inp).mf(j).params(2) = pop(i,prm+1);
            prm = prm + 2;
        end
    end

    for j=1:length(fis.output.mf)
        fis.output.mf(j).params = pop(i,prm:prm+n);
        prm = prm + n + 1;
    end

    calc_out = evalfis(fis, dataset(:,1:end-1));
    fitness(i,1) = sum((dataset(:,end)-calc_out).^2)/length(dataset(:,end));
end


function y = sphere(x)
    sumsp = 0;
    for i=1:length(x)
        sumsp = sumsp + x(i)^2;
    end
    y = sumsp;
end