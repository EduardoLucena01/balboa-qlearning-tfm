%load Q_table.mat;

[nf,nc] = size(matriz);
Q_table_bin = zeros(nf,nc);

for i=1:nf
    [maximo, pos] = max(matriz(i,:));
    for j = 1:nc
        if j==pos
            Q_table_bin(i,j)=1;
        else
            Q_table_bin(i,j)=0;
        end
    end
end


filename = "data.txt";

% Abrir el archivo para escritura (sobrescribe el archivo si ya existe)
fid = fopen(filename, 'w');

% Verificar que el archivo se abrió correctamente
if fid == -1
    error('No se pudo abrir el archivo para escritura.');
end
            
% Recorrer la matriz por filas y escribir cada elemento en una línea
for i = 1:nf
    for j = 1:nc
        fprintf(fid, '%i\n', Q_table_bin(i,j)); % Guarda el elemento y realiza salto de línea
    end
end

% Cerrar el archivo
fclose(fid);

% Mostrar mensaje de confirmación
disp(['Matriz guardada en el archivo: ' filename]);
