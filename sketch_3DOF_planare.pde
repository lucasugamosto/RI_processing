//Progettazione di un robot 3DOF con tutti i giunti di tipo rotoidale (il tutto nel piano)

//INTERAZIONE CON I PULSANTI:
//Premendo il tasto "1" sulla tastiera si può cambiare il gomito poichè questo corrisponde a cambiare il segno della soluzione di sen(q2)
//Premendo le frecce direzionali SX e/o DX è possibile variarie il valore di k (compreso tra -1 e 0)
//Premendo le frecce direzionali UP/DOWN è possibile variare l'angolo totale "phi"

float q1 = 0.0;                    //variabile di giunto del primo link
float q2 = 0.0;                    //variabile di giunto del secondo link
float q3 = 0.0;                    //variabile di giunto del terzo link
float phi = 0.0;                   //angolo data dalla somma delle tre variabili rotoidali
float q1ref = 0.0;
float q2ref = 0.0;
float q3ref = 0.0;
float xxx = 0.0;                    //variabile che indica la coordinata x dell'end-effector
float yyy = 0.0;                    //variabile che indica la coordinata y dell'end-effector
float xx = 0.0;                     //coordinate lungo x del giunto xxx-L3*cos(phi), cioè del polso sferico
float yy = 0.0;                     //coordinate lungo y del giunto yyy-L3*sin(phi), cioè del polso sferico

int gomito = 1;                     //variabile che indica con quale dei due modi possibili può essere raggiunta la posizione desiderata
float k = -0.04;                    //affinchè il sistema sia stabile gli autovalori devono essere in modulo minore di 1


//la funzione "setup()" viene eseguita da calcolatore una volta sola ed appena viene eseguito il codice
void setup() {
  size(700,700);                    //inizializzazione della finestra di lavoro definendone le dimensioni
  background(#63C9F0);              //assegnazione del colore allo sfondo della finestra di lavoro
}


//la funzione "draw()" viene eseguita ininterrottamente dopo l'esecuzione del programma
void draw() {
  background(#63C9F0);              //assegnazione del colore allo sfondo della finestra di lavoro così da cancellare il disegno del frame precedente
  
  //dimensione dei link che si andranno a realizzare
  float L1 = 100.0;
  float D1 = 20.0;
  float L2 = 100.0;
  float D2 = 20.0;
  float L3 = 100.0;
  float D3 = 20.0;
  
  translate(350,350);               //ci si sposta al centro della finestra di lavoro
  fill(255);                        //gli oggetti successivi a tale funzione saranno colorati internamente di bianco
  circle(0,0,2*L1+2*L2+2*L3);       //circonferenza che indica tutti i punti raggiungibili dall'end-effector del robot RR
  fill(237,217,29,125);
  circle(0,0,2*L1+2*L2);
  fill(0,0,255,125);
  
  //le coordinate saranno calcolate considerando la posizione del mouse sulla finestra di lavoro
  //coordinate dell'end-effector
  xxx = mouseX-350;
  yyy = mouseY-350;
  
  //coordinate del polso sferico
  xx = xxx-L3*cos(phi);
  yy = yyy-L3*sin(phi);
  
  //studio della cinematica inversa e calcolo dei valori q1ref, q2ref, q3ref
  float a = (xx*xx + yy*yy - L1*L1 - L2*L2)/(2*L1*L2);
  float c2 = a;
  float s2 = gomito*sqrt(abs(1-a*a));
  
  float A = L1 + L2*c2;
  float B = L2*s2;
  
  float c1 = A*xx+B*yy;
  float s1 = A*yy-B*xx;
  
  q1ref = atan2(s1,c1);
  q2ref = atan2(s2,c2);
  q3ref = phi - q1ref - q2ref;
  
  q1 = q1 + k*(q1-q1ref);               //evoluzione della variabile rotoidale q1
  q2 = q2 + k*(q2-q2ref);               //evoluzione della variabile rotoidale q2
  q3 = q3 + k*(q3-q3ref);               //evoluzione della variabile rotoidale q3
  
  robot(q1,q2,q3,L1,D1,L2,D2,L3,D3);    //progettazione del robot vero e proprio
  
  //tramite la seguente funzione è possibile rappresentare sulla finestra di lavoro la posizione del puntatore
  if(xx*xx + yy*yy <= L1*L1 + L2*L2 + 2*L1*L2) {
    //il puntatore si colora di verde a rappresentare che il punto è raggiungibile
    fill(0,255,0,125);
    circle(xxx,yyy,D1);
  }
  else {
    //il puntatore si colora di rosso a rappresentare che il punto non è raggiungibile
    fill(255,0,0,125);
    circle(xxx,yyy,D1);
  }
  
  translate(-350,-350);
  textSize(20);
  fill(0);
  //il valore restituito da queste variabili è positivo verso il basso e negativo verso l'altro proprio perchè y è positivo verso il basso
  text("xxx:", 550,35);
  text(xxx,600,35);
  text("yyy:",550,70);
  text(yyy,600,70);
  text("phi:",10,35);
  text((phi*180)/PI,50,35);
  text("k:",10,70);
  text(k,50,70);
}

//la funzione seguente riceve in ingresso i parametri con cui definire le dimensioni dei link del robot
void robot(float q1, float q2, float q3, float L1, float D1, float L2, float D2, float L3, float D3) {
  pushMatrix();
  link(q1,L1,D1);
  link(q2,L2,D2);
  link(q3,L3,D3);
  popMatrix();
}

void link(float q, float L, float D) {
  rotate(q);                //il sistema di riferimento viene ruotato di una quantità variabile
  
  //rappresentazione del link per mezzo delle seguenti funzioni
  ellipse(0,0,D,D);
  rect(0,-D/2,L,D);
  translate(L,0);
  ellipse(0,0,D,D);
}

/*
void mousePressed() {
  float L1 = 100.0;
  float L2 = 100.0;
  float L3 = 100.0;
  
  //le coordinate saranno calcolate considerando la posizione del mouse sulla finestra di lavoro
  xxx = mouseX-350;
  yyy = mouseY-350;
  
  xx = xxx-L3*cos(phi);
  yy = yyy-L3*sin(phi);
  
  //studio della cinematica inversa e calcolo dei valori q1ref, q2ref, q3ref
  float a = (xx*xx + yy*yy - L1*L1 - L2*L2)/(2*L1*L2);
  float c2 = a;
  float s2 = gomito*sqrt(abs(1-a*a));
  
  float A = L1 + L2*c2;
  float B = L2*s2;
  
  float c1 = A*xx+B*yy;
  float s1 = A*yy-B*xx;
  
  q1ref = atan2(s1,c1);
  q2ref = atan2(s2,c2);
  q3ref = phi-q1ref-q2ref;
}*/


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
  
  //aumenta o diminuisce l'incremento da apportare all'angolo phi, affinchè un punto nello spazio operativo sia raggiungibilie
  if(keyCode == UP) {
    phi = phi + PI/180;
  }
  if(keyCode == DOWN) {
    phi = phi - PI/180;
  }
}
