//Progettazione di un robot 2DOF con entrambi i giunti di tipo rotoidale (il tutto nel piano).

//INTERAZIONE CON I PULSANTI:
//La variabile "gomito", che indica quale delle due soluzioni si usa, è inizializzata ad 1 e può essere cambiata per mezzo del tasto '1';
//E' possibile variare il valore di k (sempre mantenuto tra -1 ed 0) tramite le frecce RIGHT e LEFT (rispettivamente k aumenta o diminuisce);

float q1 = 0.0;                   //variabile di giunto del primo link
float q2 = 0.0;                   //variabile di giunto del secondo link
float q1ref = 0.0;
float q2ref = 0.0;
float xx = 0.0;                   //variabile che indica la coordinata x dell'end-effector
float yy = 0.0;                   //variabile che indica la coordinata y dell'end-effector

float gomito = 1;                 //variabile che indica con quale dei due modi possibili può essere raggiunta la posizione desiderata
float k = -0.04;                  //affinchè il sistema sia stabile (a tempo discreto) gli autovalori devono essere in modulo minore di 1


//la funzione "setup()" viene eseguita dal calcolatore una volta sola ed appena viene eseguito il codice
void setup() {
  size(700,700);                  //inizializzazione della finestra di lavoro definendone le dimensioni
  background(#63C9F0);            //assegnazione del colore allo sfondo della finestra di lavoro
}


//la funzione "draw()" viene eseguita ininterrottamente dopo l'esecuzione del programma
void draw() {
  background(#63C9F0);            //assegnazione del colore allo sfondo della finestra di lavoro così da cancellare il disegno del frame precedente
  
  //dimensioni dei due link del robot
  float L1 = 100.0;
  float D1 = 20.0;
  float L2 = 100.0;
  float D2 = 20.0;
  
  translate(350,350);             //ci si sposta al centro della finestra di lavoro
  fill(255);                      //gli oggetti successivi a tale funzione saranno colorati internamente di bianco
  circle(0,0,2*L1+2*L2);          //circonferenza che indica tutti i punti raggiungibili dall'end effector del robot RR
  fill(0,0,255,125);
  
  //le coordinate saranno calcolate considerando la posizione del mouse sulla finestra di lavoro
  xx = mouseX-350;
  yy = mouseY-350;
  
  //studio della cinematica inversa e calcolo dei valori q1ref e q2ref
  float a = (xx*xx + yy*yy - L1*L1 -L2*L2)/(2*L1*L2);
  float c2 = a;
  float s2 = gomito*sqrt(abs(1 - a*a));
  
  float A = L1 + L2*c2;
  float B = L2*s2;
  
  float c1 = (A*xx + B*yy);
  float s1 = (A*yy - B*xx);
  
  q2ref = atan2(s2,c2);
  q1ref = atan2(s1,c1);
  
  q1 = q1 + k*(q1 - q1ref);       //evoluzione della variabile q1
  q2 = q2 + k*(q2 - q2ref);       //evoluzione della variabile q2
  
  //funzione "robot" utilizzata per la realizzazione del robot con le dovute misure passate in ingresso
  robot(q1,q2,L1,D1,L2,D2);       //progettazione del robot vero e proprio
  
  //tramite le seguenti funzioni è possibilie rappresentare sulla finestra di lavoro la posizione del puntatore
  if(xx*xx + yy*yy < L1*L1 + L2*L2 + 2*L1*L2) {
    //il puntatore appare di colore verde per mostrare che quel punto è raggiungibile dall'end-effector
    fill(0,255,0,125);
    circle(xx,yy,D1);
  }
  else {
    //il puntatore appare di colore rosso per mostrare che quel punto non è raggiungibile dall'end-effector
    fill(255,0,0,125);
    circle(xx,yy,D1);
  }
  
  //tramite le seguenti funzioni si rappresenta a schermo il valore di alcune variabili fondamentali
  translate(-350,-350);
  textSize(20);
  fill(0);
  text("k:",10,35);
  text(k,30,35);
  
  //il valore restituito da queste variabili è positivo verso il basso e negativo verso l'altro proprio perchè y è positivo verso il basso
  text("q1:",10,70);
  text((q1*180)/PI,40,70);
  text("q2:",10,105);
  text((q2*180)/PI,40,105);
  text("x:",500,35);
  text(xx,525,35);
  text("y:",500,70);
  text(yy,525,70);
}

//la funzione seguente riceve in ingresso i parametri con cui definire le dimensioni dei link del robot
void robot(float q1, float q2, float L1, float D1, float L2, float D2) {
  pushMatrix();
  link(q1,L1,D1);
  link(q2,L2,D2);
  popMatrix();
}

//la funzione "link(...)" riceve in ingresso i parametri associati all'i-esimo link
void link(float q, float L, float D) {
  rotate(q);                      //il sistema di riferimento viene ruotato di una quantità variabile q
  
  //rappresentazione del link per mezzo delle seguenti funzioni
  ellipse(0,0,D,D);
  rect(0,-D/2,L,D);
  translate(L,0);
  ellipse(0,0,D,D);
}

/*
void mousePressed() {
  float L1 = 100;
  float L2 = 100;
  
  //le coordinate saranno calcolate considerando la posizione del mouse sulla finestra di lavoro
  xx = mouseX-350;
  yy = mouseY-350;
  
  
  //studio della cinematica inversa e calcolo dei valori q1ref e q2ref
  float a = (xx*xx + yy*yy - L1*L1 -L2*L2)/(2*L1*L2);
  float c2 = a;
  float s2 = gomito*sqrt(abs(1 - a*a));
  
  float A = L1 + L2*c2;
  float B = L2*s2;
  
  float c1 = (A*xx + B*yy);
  float s1 = (A*yy - B*xx);
  
  q2ref = atan2(s2,c2);
  q1ref = atan2(s1,c1);
}
*/

void keyPressed() {
  if(keyCode == '1') {
    gomito = -gomito;
  }
  if(keyCode == RIGHT) {
    if(k < 0) {
      k = k + 0.01;
    }
    else {
      k = -0.04;
    }
  }
  if(keyCode == LEFT) {
    if(k > -0.9) {
      k = k - 0.01;
    }
    else {
      k = -0.04;
    }
  }
}
