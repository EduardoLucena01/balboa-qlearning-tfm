#include <Balboa32U4.h>
#include <Wire.h>
#include <LSM6.h>
#include <math.h>
//#include <EEPROM.h>

#define N_lim_ang 8
#define N_lim_gir 6
#define N_actions 9
#define gamma 0.95
#define epsilon 0.2
#define learning_rate 0.1
#define N_training_episodes 10
#define max_steps 10000           
#define N_ITERATIONS 300          //Calibración del giróscopo
#define alpha 0.98                //Filtro complementario
#define delay_time 25



float Q_table[(N_lim_ang-1)*(N_lim_gir-1)][N_actions];
float v_reward[N_training_episodes];
float v_nsteps[N_training_episodes];
const float actions[N_actions] = {0, 50, -50, 100, -100, 150, -150, 200, -200};
const uint8_t lim_ang[N_lim_ang] = {0, 40, 60, 75, 95, 110, 130, 175}; 
const int lim_gir[N_lim_gir] = {-1000, -150, -50, 50, 150, 1000};             

Balboa32U4ButtonA buttonA;
Balboa32U4ButtonB buttonB;
Balboa32U4ButtonC buttonC;
Balboa32U4Buzzer buzzer;
Balboa32U4Motors motors;
LSM6 imu;

float gYzero = 0;



int episodio_init;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  if (!imu.init())
  {
    // Failed to detect the LSM6.
    ledRed(1);
    while(1)
    {
      Serial.println(F("Failed to detect the LSM6."));
      delay(100);
    }
  }
  imu.enableDefault();

  // Set the gyro full scale to 1000 dps because the default
  // value is too low, and leave the other settings the same.
  imu.writeReg(LSM6::CTRL2_G, 0b10001000);

  // Set the accelerometer full scale to 16 g because the default
  // value is too low, and leave the other settings the same.
  imu.writeReg(LSM6::CTRL1_XL, 0b10000100);

  girocalibration();

  ledRed(1);
  ledYellow(1);
  ledGreen(1);
  boolean b1 = true;
  while (b1)
  {
    if (buttonA.isPressed())
    {
      b1 = false;
      episodio_init = 0;
      inicializartabla();
    }
    else if (buttonB.isPressed())
    {
      b1 = false;
      cargartabla();
    }
  }
  ledRed(0);
  ledYellow(0);
  ledGreen(0);
  delay(3000);
  boolean b2 = true;
  //AVISO DE MATRIZ PREPARADA, ASÍ EL USUARIO PUEDE EMPEZAR CUANDO QUIERA
  while (b2){
    buzzer.playFrequency(220, 50, 8);
    ledRed(1);
    if (buttonA.isPressed())
    {
      b2 = false;
      ledRed(0);
    }
  }
  mostrartabla();
  delay(2000);
  randomSeed(millis());
  buttonA.waitForButton();
}


void loop() {
  delay(2000);
  learn();

  while (!buttonA.isPressed()){
    buzzer.playFrequency(300, 500, 15);
    delay(1000);
  }
  buttonC.waitForButton();
  enviardatos();
  while (true){
    delay(1000);
  }

  
}

void inicializartabla(){
  for (size_t i = 0; i<(N_lim_ang-1)*(N_lim_gir-1); i++)
  {
    for (size_t j = 0; j<N_actions; j++)
    {
      Q_table[i][j] = 0;
    }
  }
}

void mostrartabla(){
  for (size_t i = 0; i<(N_lim_ang-1)*(N_lim_gir-1); i++)
    {
      for (size_t j = 0; j<N_actions; j++)
      {
        Serial.print(Q_table[i][j]);
        Serial.print("  ");
      }
      Serial.println();
    }
}

void enviardatos(){
  for (size_t i = 0; i<(N_lim_ang-1)*(N_lim_gir-1); i++)
  {
    for (size_t j = 0; j<N_actions; j++)
    {
      Serial.println(Q_table[i][j]);
      delay(5);
    }
  }
  for (size_t i = 0; i<N_training_episodes; i++){
    Serial.println(v_reward[i]);
    delay(5);
  }
  for (size_t i = 0; i<N_training_episodes; i++){
    Serial.println(v_nsteps[i]);
    delay(5);
  }
}

void girocalibration(){
  //AXIS Y
  float totaly = 0;
  gYzero = 0;
  for (int i = 0; i<N_ITERATIONS; i++)
  {
    imu.read();
    totaly = totaly + imu.g.y;
    delay(1);
  }
  gYzero = totaly / N_ITERATIONS;
}

//La matriz Q será global
uint8_t greedy_policy(uint8_t state){
  float maximo = Q_table[state][0];
  
  for (int i = 1; i < N_actions; i++){
    if (Q_table[state][i]>maximo){
      maximo = Q_table[state][i];
    }
  }

  int indices_max[N_actions];
  uint8_t contador = 0;
  for (size_t i = 0; i<N_actions; i++){
    if (Q_table[state][i]==maximo){
      indices_max[contador] = i;
      contador++;
    }
  }

  int randomIndex = random(0, contador);
  return indices_max[randomIndex];
}


//epsilon será global
float epsilon_greedy_policy(uint8_t state){
  uint8_t action = 0;
  if ((random(0, 10000) / 10000.0) > epsilon){
    action = greedy_policy(state);
  }
  else{
    action = random(0,N_actions);
  }
  return action;
}

String inputString = "";
uint8_t fila = 0, columna = 0;
boolean receiving = true;

void cargartabla(){
  boolean t = true;
  while (t){
    while (Serial.available()) {
      char inChar = Serial.read();  // Leer un carácter del puerto serie

      if (inChar == ',') {  
        Q_table[fila][columna] = inputString.toFloat();  // Convertir a float
        inputString = "";  // Reiniciar buffer
        columna++;
        
        if (columna >= N_actions) {  // Si completamos una fila
          columna = 0;
        }
      } 
      else if (inChar == '\n') {  // Fin de una fila
        if (inputString.length() > 0) {
          Q_table[fila][columna] = inputString.toFloat();
          inputString = "";
        }
        fila++;
        columna = 0;
      }
      else {
        inputString += inChar;  // Construir número recibido
      }

      if (inputString == "END") {  
        receiving = false;  
        t = false;
      }
  }

    //receiving = true;  // Reset para futuras recepciones
}
}


boolean terminated;

void learn(){

  uint8_t state;
  uint8_t action;
  int episode;


  for (episode = episodio_init; episode < N_training_episodes; episode++){

    
    //COLOCAR EN ESTADO INICIAL (EQUILIBRIO)
    randomSeed(micros());
    ledGreen(1);
    buzzer.playFrequency(400, 3000, 7);
    buttonA.waitForButton();
    ledGreen(0);
    float s_reward = 0;
    delay(500);

    float angle;
    for (int i = 0; i<200; i++){
      imu.read();
      angle += (atan2(imu.a.x, imu.a.z))*180/PI;
    }
    
    angle = angle/200;

    float angle_giro = 0;
    float angle_acel = angle;
    float prevgiroY = 0;
    float prevTime = micros();
    state = mapeo(angle, prevgiroY);
    terminated = false;
    int step = 0;
    
    for (step; step < max_steps; step++){
      
      action = epsilon_greedy_policy(state);
      act(action);

      delay(delay_time);
      
      imu.read();

      float currentTime = micros();
      float deltaT = currentTime-prevTime;
      prevTime = currentTime;

      float giroY = (imu.g.y-gYzero)*35/1000;
      angle_giro =  ((prevgiroY+giroY)/2.0)*deltaT*1e-6;
      prevgiroY = giroY;

      angle_acel = (atan2(imu.a.x, imu.a.z))*180/PI;

      angle = alpha*(angle-angle_giro)+(1-alpha)*angle_acel;
      uint8_t new_state = mapeo(angle, giroY);
      float reward = calculate_reward(new_state);
      s_reward += reward;
      
      Q_table[state][action] = Q_table[state][action] + learning_rate * (reward + gamma*Q_table[new_state][greedy_policy(new_state)] - Q_table[state][action]);

      if (terminated){
        act(0);
        ledRed(1);
        buzzer.playFrequency(400, 1500, 8);
        v_reward[episode] = s_reward;
        v_nsteps[episode] = step;
        delay(2000);
        ledRed(0);
        break;
      }

      if (step == max_steps-1){
        v_nsteps[episode] = max_steps;
      }

      state = new_state;
    }
    
    act(0);

    while (!buttonA.isPressed())
    {
      ledRed(1);

      if (buttonC.isPressed()){
        enviardatos();          
        while (true){
          delay(1000);
        }
      }
    }
    ledGreen(1);
    delay(500);
    ledGreen(0);
    delay(500);
  }
}

uint8_t mapeo(float angle, float giroY){
  uint8_t dg = 0;
  uint8_t da = 0;

  for (size_t i = 0; i<(N_lim_ang-1); i++){
    if (angle>lim_ang[i] && angle<lim_ang[i+1])
    {
      da = i;
      break;
    }
  }

  for (size_t i = 0; i<(N_lim_gir-1); i++){
    if (giroY>lim_gir[i] && giroY<lim_gir[i+1])
    {
      dg = i;
      break;
    }
  }
  return((uint8_t)(da*(N_lim_gir-1)+dg));
}

inline void act(uint8_t action){
  motors.setSpeeds(actions[action], actions[action]);
}

inline float calculate_reward(uint8_t newState){
  float reward = 0;

  if (newState >= ((N_lim_ang-1)/2*(N_lim_gir-1))  && newState < (N_lim_ang/2*(N_lim_gir-1))){
    reward = 5;
  }
  else if (newState >= ((N_lim_ang-2)*(N_lim_gir-1)) || newState < (N_lim_gir-1)){
    reward = -20;
    terminated = true;
  }
  
  return reward;
}

void alarma(){
  while (!buttonA.isPressed()){
    buzzer.playFrequency(400, 125, 15);
    delay(250);
  }
  buttonC.waitForButton();
  enviardatos();
  while (true){
    delay(1000);
  }
}