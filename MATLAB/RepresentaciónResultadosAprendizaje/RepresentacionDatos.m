load WorkSpaceDatos.mat;
%% PREPARACIÓN DE DATOS

steps_10ms_cum = cumsum(steps_10ms);
steps_25ms_cum = cumsum(steps_25ms);
steps_40ms_cum = cumsum(steps_40ms);
steps_55ms_cum = cumsum(steps_55ms);

tiempo_entrenamiento_10ms = steps_10ms_cum * 0.013;
tiempo_entrenamiento_25ms = steps_25ms_cum * 0.028;
tiempo_entrenamiento_40ms = steps_40ms_cum * 0.043;
tiempo_entrenamiento_55ms = steps_55ms_cum * 0.058;

factor_suavizado = 15;

%% RECOMPENSA EN FUNCIÓN DE NÚMERO DE EPISODIO SIN SUAVIZAR

figure;
plot(reward_10ms);
hold on;
plot(reward_25ms);
plot(reward_40ms);
plot(reward_55ms);
xlabel("Número de episodio");
ylabel("Recompensa acumulada");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("RECOMPENSA EN FUNCIÓN DE NÚMERO DE EPISODIO");


%% RECOMPENSA EN FUNCIÓN DE NÚMERO DE EPISODIO SUAVIZADO

figure;
plot(smooth(reward_10ms,factor_suavizado));
hold on;
plot(smooth(reward_25ms,factor_suavizado));
plot(smooth(reward_40ms,factor_suavizado));
plot(smooth(reward_55ms,factor_suavizado));
xlabel("Número de episodio");
ylabel("Recompensa acumulada");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("RECOMPENSA EN FUNCIÓN DE NÚMERO DE EPISODIO (SUAVIZADO)");



%% RECOMPENSA EN FUNCIÓN DEL TIEMPO SIN SUAVIZAR

figure;
plot(tiempo_entrenamiento_10ms, reward_10ms);
hold on;
plot(tiempo_entrenamiento_25ms, reward_25ms);
plot(tiempo_entrenamiento_40ms, reward_40ms);
plot(tiempo_entrenamiento_55ms, reward_55ms);
xlabel("Tiempo (s)");
ylabel("Recompensa acumulada");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("RECOMPENSA EN FUNCIÓN DEL TIEMPO DE ENTRENAMIENTO");



%% RECOMPENSA EN FUNCIÓN DEL TIEMPO SUAVIZADO

figure;
plot(tiempo_entrenamiento_10ms, smooth(reward_10ms,factor_suavizado));
hold on;
plot(tiempo_entrenamiento_25ms, smooth(reward_25ms,factor_suavizado));
plot(tiempo_entrenamiento_40ms, smooth(reward_40ms,factor_suavizado));
plot(tiempo_entrenamiento_55ms, smooth(reward_55ms,factor_suavizado));
xlabel("Tiempo (s)");
ylabel("Recompensa acumulada");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("RECOMPENSA EN FUNCIÓN DEL TIEMPO DE ENTRENAMIENTO (SUAVIZADO)");


%% TIEMPO EN EQUILIBRIO EN FUNCIÓN DE NÚMERO DE EPISODIOS SIN SUAVIZAR

figure;
plot(steps_10ms*13);
hold on;
plot(steps_25ms*28);
plot(steps_40ms*43);
plot(steps_55ms*58);
xlabel("Número de episodios");
ylabel("Tiempo (ms)");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("TIEMPO EN EQUILIBRIO DURANTE EL ENTRENAMIENTO EN FUNCIÓN DE NÚMERO DE EPISODIO");




%% TIEMPO EN EQUILIBRIO EN FUNCIÓN DE NÚMERO DE EPISODIOS SUAVIZADO

figure;
plot(smooth(steps_10ms*13,factor_suavizado));
hold on;
plot(smooth(steps_25ms*28,factor_suavizado));
plot(smooth(steps_40ms*43,factor_suavizado));
plot(smooth(steps_55ms*58,factor_suavizado));
xlabel("Número de episodios");
ylabel("Tiempo (ms)");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("TIEMPO EN EQUILIBRIO DURANTE EL ENTRENAMIENTO EN FUNCIÓN DE NÚMERO DE EPISODIO (SUAVIZADO)");

%% TIEMPO EN EQUILIBRIO EN FUNCIÓN DE NÚMERO DE EPISODIOS SIN SUAVIZAR

figure;
plot(tiempo_entrenamiento_10ms,steps_10ms*13);
hold on;
plot(tiempo_entrenamiento_25ms,steps_25ms*28);
plot(tiempo_entrenamiento_40ms,steps_40ms*43);
plot(tiempo_entrenamiento_55ms,steps_55ms*58);
xlabel("Tiempo (s)");
ylabel("Tiempo (ms)");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("TIEMPO EN EQUILIBRIO DURANTE EL ENTRENAMIENTO EN FUNCIÓN DEL TIEMPO DE ENTRENAMIENTO");




%% TIEMPO EN EQUILIBRIO EN FUNCIÓN DE NÚMERO DE EPISODIOS SUAVIZADO

figure;
plot(tiempo_entrenamiento_10ms,smooth(steps_10ms*13, factor_suavizado));
hold on;
plot(tiempo_entrenamiento_25ms,smooth(steps_25ms*28, factor_suavizado));
plot(tiempo_entrenamiento_40ms,smooth(steps_40ms*43, factor_suavizado));
plot(tiempo_entrenamiento_55ms,smooth(steps_55ms*58, factor_suavizado));
xlabel("Tiempo (s)");
ylabel("Tiempo (ms)");
legend("Delay 10 ms","Delay 25 ms","Delay 40 ms","Delay 55 ms");
title("TIEMPO EN EQUILIBRIO DURANTE EL ENTRENAMIENTO EN FUNCIÓN DEL TIEMPO DE ENTRENAMIENTO");
