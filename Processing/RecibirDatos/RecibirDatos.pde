import processing.serial.*;

Serial myPort;
int N_lim_ang = 36;
int N_lim_gir = 2;
int N_actions = 9;
int N_rewards = 10;
int N_elements=(N_lim_ang-1)*(N_lim_gir-1)*N_actions+2*N_rewards;
PrintWriter writer;
String val;

void setup()
{
  String portName = "COM3";
  myPort = new Serial(this, portName, 9600);
  writer = createWriter("data.txt");
}

int i = 0;
void draw()
{
  if (myPort.available()>0 && i<N_elements){
    val = myPort.readStringUntil('\n');
    //val = val.replace('.',',');
    writer.print(val);
    i++;
    //println(i);
  }
  if (i>=N_elements){
    writer.close();
    println("FIN");
    fin();
  }
}

void fin(){
  while (true)
  {
    delay(1000);
  }   
}
