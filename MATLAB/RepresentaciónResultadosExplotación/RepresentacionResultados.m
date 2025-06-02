load WorkspaceDatos.mat


%% RECOMPENSA EN EXPLOTACIÓN

figure;
data=[reward_10ms' reward_25ms' reward_40ms' reward_55ms'];
boxplot(data,["delay 10 ms","delay 25 ms","delay 40 ms","delay 55 ms"]);
xlabel("Delays empleados");
ylabel("Recompensa");
title("RECOMPENSA ACUMULADA POR EPISODIO EN EXPLOTACIÓN");



%% TIEMPO EN EQUILIBRIO EN EXPLOTACIÓN

figure;
data=[(steps_10ms*13)' (steps_25ms*28)' (steps_40ms*43)' (steps_55ms*58)'];
boxplot(data,["delay 10 ms","delay 25 ms","delay 40 ms","delay 55 ms"]);
xlabel("Delays empleados");
ylabel("Tiempo(ms)");
title("TIEMPO EN EQUILIBRIO POR EPISODIO EN EXPLOTACIÓN");



