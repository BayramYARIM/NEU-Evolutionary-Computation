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
opt.NumMembershipFunctions = 4;
fis = genfis(dataset(:,1:end-1),dataset(:,end), opt);
for inp=fis.input
    inp.Range = [-5.12 5.12];
end

len_inp_params = length(fis.input) * opt.NumMembershipFunctions * 2;
len_out_params = length(fis.output.mf) * (n+1);
total_params = len_inp_params + len_out_params;
len_pop = 40;
pc = 0.8; %0.25; %0.7 - 0.9
pm = 0.1; %0.001; % 0.08 - 0.1

fitness = zeros(len_pop,1);

pop = -5.12 + 10.24*rand(len_pop, total_params);
pop = pop + 0.001;

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

    calc_out = evalfis(dataset(:,1:end-1), fis);
    fitness(i,1) = sum((dataset(:,end)-calc_out).^2)/length(dataset(:,end));
end

% iter
%while min(fitness)>100
for iter=1:200
    uyg = zeros(len_pop,1);
    for i=1:len_pop
        uyg(i,1) = (1/fitness(i))/sum(1./fitness);
    end
    kuml = cumsum(uyg);
    [~, bestind] = min(fitness);
    elit = pop(bestind, :);
    
    tempcrom = zeros(len_pop, total_params);
    for i=1:len_pop
        tempcrom(i,:) = pop(find(rand <= kuml,1),:);
    end

    crossRand = find(pc >= rand(len_pop,1));
    if mod(length(crossRand),2)
        crossRand(end,:) = [];
    end

    while isempty(crossRand)
        crossRand = find(pc >= rand(len_pop,1));
        if mod(length(crossRand),2)
            crossRand(end,:) = [];
        end
    end
    % Aritmetik çaprazlama
    alfa = rand(); % 0.3; % rand
    for i=1:2:length(crossRand)
        for j=1:total_params
            tempcrom(crossRand(i),j) = tempcrom(crossRand(i),j)*alfa+(1-alfa)*tempcrom(crossRand(i+1),j);
            tempcrom(crossRand(i+1),j) = tempcrom(crossRand(i+1),j)*alfa+(1-alfa)*tempcrom(crossRand(i),j);
        end
    end

    % 40X16 - rand
    mutRand = find(pm >= rand(len_pop, total_params));
    if isempty(mutRand) == 0
        for i=1:length(mutRand)
            tempcrom(mutRand(i)) = -5.12 + 10.24*rand();
        end
    end

    pop = [elit; tempcrom];
    
    for i=1:len_pop
        prm = 1;
        for inp=1:n
            for j=1:length(fis.input(inp).mf)
                fis.input(inp).mf(j).params(1) = abs(pop(i,prm))+0.001;
                fis.input(inp).mf(j).params(2) = pop(i,prm+1);
                prm = prm + 2;
            end
        end
    
        for j=1:length(fis.output.mf)
            fis.output.mf(j).params = pop(i,prm:prm+n);
            prm = prm + n + 1;
        end
    
        calc_out = evalfis(dataset(:,1:end-1), fis);
        fitness(i,1) = sum((dataset(:,end)-calc_out).^2)/length(dataset(:,end));
    end
    disp(min(fitness));
end

[v,i] = min(fitness);
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
    

function y = sphere(x)
    sumsp = 0;
    for i=1:length(x)
        sumsp = sumsp + x(i)^2;
    end
    y = sumsp;
end