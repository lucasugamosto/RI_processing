//Procedura 24: Cinematica inversa con Newton per il 3DOF planare in Processing e paragone con la cinematica inversa classica

//INTERAZIONE CON I PULSANTI:
//Premendo il tasto "1" sulla tastiera si può cambiare il gomito poichè questo corrisponde a cambiare il segno della soluzione di sen(q2)
//Premendo le frecce direzionali SX e/o DX è possibile variarie il valore di k (compreso tra -1 e 0)
//Premendo le frecce direzionali UP/DOWN è possibile variare l'angolo totale "phi" di 0.5 gradi

//variabili di giunto associate alla cinematica inversa classica
float q1 = 0.0;
float q2 = 0.0;
float q3 = 0.0;
float q1ref;
float q2ref;
float q3ref;

//variabili di giunto associate alla cinematica inversa con Newton
float q1Cap_old = PI/3;                 //viene posta diversa da zero poichè nell'evoluzione dell'algoritmo causerebbe sempre valore nullo
float q2Cap_old = PI/3;                 //viene posta diversa da zero poichè nell'evoluzione dell'algoritmo causerebbe sempre valore nullo
float q1Cap_new = 0.0;
float q2Cap_new = 0.0;
float q3Cap_new = 0.0;

//altre variabili utili
float phi = 0.0;                        //angolo tra il sistema di riferimento in base e il sistema di riferimento dell'end-effector
int gomito = -1;                         //variabile che indica con quale dei due modi possibili può essere raggiunta la posizione desiderata
float k = -0.04;                        //autovalore in modulo minore di 1 affinchè il sistema sia stabile

float xxx = 0.0;                        //variabile che indica la coordinata lungo x dell'end-effector
float yyy = 0.0;                        //variabile che indica la coordinata lungo y dell'end-effector
float xx = 0.0;                         //variabile che indica la coordinata lungo x del polso sferico (xxx-L3*cos(phi))
float yy = 0.0;                         //variabile che indica la coordinata lungo y del polso sferico (yyy-L3*sin(phi))

//altre variabili associate alla cinematica inversa con Newton
float T = 0.01;                         //tempo di campionamento della variabile di giunto
float lambda = 100.0;                    //tau = 1/lamda, dove tau è la costante di tempo
float PTilde_x = 0.0;                   //errore di stima lungo x (differenza tra P e P cappello)
float PTilde_y = 0.0;                   //errore di stima lungo y (differenza tra P e P cappello)

float[][] jacobInv = new float[2][2];   //le prime parentesi quadre indicano il numero di colonne, le seconde il numero di righe

float xxP;
float yyP;
float PTilde_xP;
float PTilde_yP;

void setup() {
  size(700,700);                    //inizializzazione della finestra di lavoro definendone le dimensioni
  background(#63C9F0);              //assegnazione del colore allo sfondo della finestra di lavoro
  
  //inizializzazione degli elementi della matrice jacobiana a 0
  for(int i = 0; i < 2; i++) {
   for(int j = 0; j < 2; j++) {
    jacobInv[i][j] = 0.0;
   }
  }
}

void draw() {
  background(#63C9F0);
  
  //con le seguenti variabili inizializzo le dimensioni dei link che si andranno a realizzare
  float L1 = 100.0;
  float L2 = 100.0;
  float L3 = 100.0;
  float D1 = 20.0;
  float D2 = 20.0;
  float D3 = 20.0;
  
  translate(350,350);                    //ci si sposta al centro della finestra di lavoro
  fill(255);                             //gli oggetti successivi a tale funzione saranno colorati internamente di bianco
  circle(0,0,2*L1+2*L2+2*L3);            //circonferenza che indica tutti i punti raggiungibili dall'end-effector del robot RRR
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
  
  //studio della cinematica inversa con il metodo classico
  float a = (xx*xx + yy*yy - L1*L1 - L2*L2)/(2*L1*L2);
  float c2 = a;
  float s2 = gomito*sqrt(abs(1-a*a));
  
  float A = L1 + L2*c2;
  float B = L2*s2;
  
  float c1 = A*xx + B*yy;
  float s1 = A*yy - B*xx;
  
  q1ref = atan2(s1,c1);
  q2ref = atan2(s2,c2);
  q3ref = phi-q1ref-q2ref;
  
  q1 = q1 + k*(q1-q1ref);                 //evoluzione della variabile di giunto rotoidale q1
  q2 = q2 + k*(q2-q2ref);                 //evoluzione della variabile di giunto rotoidale q2
  q3 = q3 + k*(q3-q3ref);                 //evoluzione della variabile di giunto rotoidale q3
  
  //studio della cinematica inversa con l'equazione di Newton a tempo discreto
  jacobInv[0][0] = cos(q2Cap_old+q1Cap_old)/(L1*sin(q2Cap_old));                                  //elemento in prima riga e prima colonna della matrice jacobInv
  jacobInv[1][0] = sin(q2Cap_old+q1Cap_old)/(L1*sin(q2Cap_old));                                  //elemento in prima riga e seconda colonna della matrice jacobInv
  jacobInv[0][1] = -(L2*cos(q2Cap_old+q1Cap_old)+L1*cos(q1Cap_old))/(L1*L2*sin(q2Cap_old));       //elemento in seconda riga e prima colonna della matrice jacobInv
  jacobInv[1][1] = -(L2*sin(q2Cap_old+q1Cap_old)+L1*sin(q1Cap_old))/(L1*L2*sin(q2Cap_old));       //elemento in seconda riga e seconda colonna della matrice jacobInv
  
  if(xx*xx + yy*yy <= L1*L1 + L2*L2 + 2*L1*L2) {
    //caso in cui il punto da voler raggiungere con l'end-effector è nello spazio operativo
    PTilde_x = xx - (L2*cos(q2Cap_old+q1Cap_old)+L1*cos(q1Cap_old));                                //calcolo dell'errore di stima all'istante precedente k-1 lungo x
    PTilde_y = yy - (L2*sin(q2Cap_old+q1Cap_old)+L1*sin(q1Cap_old));                                //calcolo dell'errore di stima all'istante precedente k-1 lungo y
  
    q1Cap_new = q1Cap_old + (T*lambda/2)*(jacobInv[0][0]*PTilde_x + jacobInv[1][0]*PTilde_y);
    q2Cap_new = q2Cap_old + (T*lambda/2)*(jacobInv[1][0]*PTilde_x + jacobInv[1][1]*PTilde_y);
    q3Cap_new = phi-q1Cap_new-q2Cap_new;
    q1Cap_old = q1Cap_new;
    q2Cap_old = q2Cap_new;
  }
  else {
    //caso in cui il punto da voler raggiungere con l'end-effector non è nello spazio operativo
    if(xx > 0) {
      xxP = 2*L1/(sqrt(1+(yy/xx)*(yy/xx)));
      yyP = (yy/xx)*(xxP);
    }
    else if(xx < 0) {
      xxP = -2*L1/(sqrt(1+(yy*xx)*(yy*xx)));
      yyP = (yy/xx)*(xxP);
    }
   
    PTilde_xP = xxP - (L2*cos(q2Cap_old+q1Cap_old)+L1*cos(q1Cap_old));
    PTilde_yP = yyP - (L2*sin(q2Cap_old+q1Cap_old)+L1*sin(q1Cap_old));
  
    q1Cap_new = q1Cap_old + (T*lambda/2)*(jacobInv[0][0]*PTilde_xP + jacobInv[1][0]*PTilde_yP);
    q2Cap_new = q2Cap_old + (T*lambda/2)*(jacobInv[1][0]*PTilde_xP + jacobInv[1][1]*PTilde_yP);
    q3Cap_new = phi-q1Cap_new-q2Cap_new;
    q1Cap_old = q1Cap_new;
    q2Cap_old = q2Cap_new;
  }
  
  fill(0,0,255,125);
  robot(q1,q2,q3,L1,D1,L2,D2,L3,D3);                                                      //progettazione del robot con la cinematica inversa classica
  fill(245,211,15,125);
  robot(q1Cap_new,q2Cap_new,q3Cap_new,L1,D1,L2,D2,L3,D3);                                 //progettazione del robot con la cinematica inversa con Newton
  
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
  //il valore restituito da queste variabili è positivo verso il basso e negativo verso l'alto proprio perchè y è positivo verso il basso
  text("xxx:",550,35);
  text(xxx,600,35);
  text("yyy:",550,70);
  text(yyy,600,70);
  text("phi[°]:",10,35);
  text((phi*180)/PI,60,35);
  text("k:",10,70);
  text(k,50,70);
}

//la seguente funzione riceve in ingresso i parametri con cui definire le dimensioni del link del robot
void robot(float q1, float q2, float q3, float L1, float D1, float L2, float D2, float L3, float D3) {
  pushMatrix();
  link(q1,L1,D1);
  link(q2,L2,D2);
  link(q3,L3,D3);
  popMatrix();
}

//la seguente funzione riceve in ingresso i parametri associati al singolo link del robot e lo realizza
void link(float q, float L, float D) {
  rotate(q);                    //il sistema di riferimento viene ruotato di una quantità variabile
  //realizzazione del link per mezzo delle seguenti funzioni
  ellipse(0,0,D,D);
  rect(0,-D/2,L,D);
  translate(L,0);
  ellipse(0,0,D,D);
}

void keyPressed() {
  if(keyCode == '1') {
    gomito = -gomito;
  }
  if(keyCode == RIGHT) {
    if(k < 0) {
      k = k+0.01;
    }
    else {
      k = -0.04;
    }
  }
  if(keyCode == LEFT) {
    if(k > -0.9) {
      k=k-0.01;
    }
    else {
      k=-0.04;
    }
  }
  
  //aumentare o diminuire l'angolo "phi", affinchè un punto nella finestra di lavoro sia raggiungibilie
  if(keyCode == UP) {
    phi = phi + (PI*0.5)/180;
  }
  if(keyCode == DOWN) {
    phi = phi - (PI*0.5)/180;
  }
}
