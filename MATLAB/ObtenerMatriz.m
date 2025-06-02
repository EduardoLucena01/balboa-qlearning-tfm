load data.txt;

N_lim_ang = 36;
N_lim_gir = 2;
N_actions = 9;
matriz = zeros((N_lim_ang-1)*(N_lim_gir-1),N_actions);
reward = zeros(1,10);
steps = zeros(1,10);
k = 1;
for i =1:(N_lim_ang-1)*(N_lim_gir-1)
    for j = 1:N_actions
        matriz(i,j) = data(k);
        k = k+1;
    end
end

for i = 1:10
    reward(i) = data(k);
    k = k+1;
end

for i = 1:10
    steps(i) = data(k);
    k = k+1;
end

if numel(data) > 10
    % Eliminar los últimos 10 elementos
    data_modificado = data(1:end-20);
else
    % Si hay 10 o menos, dejarlo vacío
    data_modificado = [];
end

% Escribir los datos modificados de nuevo al fichero
fid = fopen("data.txt", 'w');
fprintf(fid, '%.2f\n', data_modificado);
fclose(fid);