filename = "data.txt";

% Abrir el archivo para escritura (sobrescribe el archivo si ya existe)
fid = fopen(filename, 'w');

% Verificar que el archivo se abrió correctamente
if fid == -1
    error('No se pudo abrir el archivo para escritura.');
end

% Obtener dimensiones de la matriz
[nf, nc] = size(matriz);
            
% Recorrer la matriz por filas y escribir cada elemento en una línea
for i = 1:nf
    for j = 1:nc
        fprintf(fid, '%f\n', matriz(i,j)); % Guarda el elemento y realiza salto de línea
    end
end

% Cerrar el archivo
fclose(fid);

% Mostrar mensaje de confirmación
disp(['Matriz guardada en el archivo: ' filename]);