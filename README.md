# Aprendizaje por refuerzo del robot Balboa 32U4

Este repositorio contiene el código fuente desarrollado para el Trabajo Fin de Máster titulado **"Aprendizaje por refuerzo del balanceo de un robot de dos ruedas con microcontrolador de bajas prestaciones"**. El proyecto se basa en la implementación del algoritmo Q-Learning sobre un robot Balboa 32U4, usando el entorno Arduino y herramientas complementarias como Processing y MATLAB.

---

## 📁 Estructura del repositorio

### `Arduino`
Contiene los programas implementados directamente en el microcontrolador ATmega32U4 de la placa Balboa. Incluye versiones de entrenamiento y explotación del algoritmo Q-Learning:

- `LEARN_FC`: Aprendizaje usando filtro complementario. Versión final y más estable. El estado se define solo con el ángulo.
- `LEARN_Fexp`: Aprendizaje usando filtro exponencial. Resultados menos estables.
- `LEARN_FC_angleandgyro`: Aprendizaje con filtro complementario. El estado se define con ángulo y velocidad angular.
- `EXPLOTACION_FC`: Ejecución de la política aprendida a partir de la tabla Q generada por `LEARN_FC`.

> Todas las versiones de entrenamiento exportan la tabla Q, la recompensa acumulada y el número de pasos por episodio. En `LEARN_FC_angleandgyro`, se omite el escalado por tiempo de paso.

---

### `Processing`
Programas desarrollados en Processing para facilitar la comunicación serie entre Arduino y el PC.

- `EnviarDatos`: Envío de una tabla Q almacenada previamente en fichero de texto hacia Arduino.
- `RecibirDatos`: Recepción y almacenamiento de datos enviados por Arduino tras cada bloque de entrenamiento o explotación.

---

### `MATLAB`
Scripts para tratamiento de datos y análisis posterior.

- `EscribirMatrixentxt.m`: Guarda una matriz del workspace en un fichero `.txt`.
- `ObtenerMatriz.m`: Carga los datos recibidos desde Arduino.
- `ObtenerInfoMatriz.m`: Consulta fila/columna de la Q-table y devuelve información asociada.
- `SimplificaQ_table.m`: Convierte los valores máximos de cada fila en 1, y el resto en 0, para facilitar la explotación con tipos `uint8_t`.

#### Representación de resultados:
- `RepresentaciónResultadosAprendizaje`: Script y datos para graficar evolución de la recompensa y pasos durante el entrenamiento.
- `RepresentaciónResultadosExplotación`: Script y datos para graficar resultados obtenidos al aplicar la política aprendida.

---

## ⚙️ Requisitos

- Arduino IDE
- Librería oficial `Balboa32U4` de Pololu
- Librería oficial `LSM6` de Pololu
- Processing 3.x
- MATLAB (versión estándar con funciones básicas)

---

## 🔎 Notas

- El repositorio está alineado con el contenido descrito en el capítulo 4 de la memoria.
- Para detalles sobre discretización de estados, cálculo de recompensas y estructura del algoritmo, consultar el capítulo 5 del documento principal.
- No se incluyen scripts de caracterización experimental del hardware, ya que no forman parte del núcleo del sistema de aprendizaje.

---

## 👨‍💻 Autor

Eduardo Lucena Alonso 
Escuela de Ingenierías Industriales, Universidad de Málaga
Trabajo Fin de Máster, 2025
