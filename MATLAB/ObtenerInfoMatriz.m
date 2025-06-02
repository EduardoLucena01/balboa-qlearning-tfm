function ObtenerInfoMatriz(fila, columna, matriz)
    lim_ang = [0:5:175];                     
    lim_gir = [-1000 1000];                  
    acciones = [0 50 -50 100 -100 150 -150 200 -200];
    
    n_int_ang = length(lim_ang)-1;
    n_int_gir = length(lim_gir)-1;

    valor_Q = matriz(fila, columna);
    accion = acciones(columna);

    da = fix((fila-1)/n_int_gir)+1;
    dg = mod((fila-1),n_int_gir)+1;
    
    fprintf("El elemento en la fila %i y columna %i", fila, columna);
    fprintf(" tiene un valor de %d\n",valor_Q);
    fprintf("Acción de en los motores de %i. Ángulo en el intervalo %dº : %dº. Vel de giro en el intervalo %dº/s : %dº/s. \n\n", accion, lim_ang(da), lim_ang(da+1), lim_gir(dg), lim_gir(dg+1));
        

    
end