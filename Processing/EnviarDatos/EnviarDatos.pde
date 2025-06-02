import processing.serial.*;

Serial myPort;
int N_lim_ang = 36;
int N_lim_gir = 2;
int N_actions = 9;
float[][] matriz = new float[(N_lim_ang-1)*(N_lim_gir-1)][N_actions];

void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600); // Asegurar que se usa el puerto correcto
  
  String[] lines = loadStrings("data.txt"); // Leer el archivo con los datos
  int index = 0;

  // Llenar la matriz con los datos del archivo
  for (int i = 0; i < (N_lim_ang-1)*(N_lim_gir-1); i++) {
    for (int j = 0; j < N_actions; j++) {
      matriz[i][j] = float(lines[index]); 
      index++;
    }
  }
  
  delay(2000); // Esperar a que Arduino esté listo
  sendMatrix(); 
}

void sendMatrix() {
  for (int i = 0; i < (N_lim_ang-1)*(N_lim_gir-1); i++) {
    for (int j = 0; j < N_actions; j++) {
      myPort.write(str(matriz[i][j]) + ",");  // Enviar número seguido de una coma
      delay(10);  // Pequeña pausa para evitar errores en la recepción
    }
    myPort.write("\n");  // Indicar el fin de la fila
    delay(20);
  }
  
  myPort.write("END\n");  // Indicar el fin de la transmisión
  println("Matriz enviada a Arduino.");
}
