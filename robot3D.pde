//ISTRUZIONI PER L'UTILIZZO DEL CODICE:
//1. I giunti prismatici sono rappresentati in metri. 
//   I giunti rotoidali sono rappresentati in radianti.

//2. Tasti per la scelta dei robot da visualizzare:
//    1) ROBOT CARTESIANO
//    2) ROBOT CILINDRICO
//    3) ROBOT SCARA
//    4) ROBOT SFERICO DI 1°TIPO
//    5) ROBOT SFERICO DI 2°TIPO
//    6) ROBOT ANTROPOMORFO

//3. Tasti per la scelta dei giunti da far variare nel robot precedentemente selezionato:
//    A) giunto q1
//    S) giunto q2
//    D) giunto q3
//    F) giunto q4
//    G) giunto q5
//    H) giunto q6

//4. Con il tasto '0' si resettano le variabili di giunto associando valore nullo ad esse, dove possibile
//5. Con il tasto '9' si decide se far apparire o meno i sistemi di riferimento a tutti i giunti del robot rappresentato
//6. Con le frecce direzionali 'LEFT' e 'RIGHT' rispettivamente si decrementa ed incrementa il valore del giunto selezionato
//7. Con le frecce direzionali 'DOWN' e 'UP' rispettivamente si decrementa ed incrementa il valore dell'autovalore TT (valore compreso tra -1 e 0).

//le seguenti variabili sono usate per ruotare lungo l'asse X e/o l'asse Y il robot
float angoloX = 0.0;
float angoloY = 0.0;
float angoloXp = 0.0;
float angoloYp = 0.0;

//le suguenti variabili indicano le variabili di giunto
float q1 = 0.0;
float q2 = 0.0;
float q3 = 0.0;
float q4 = 0.0;
float q5 = 0.0;
float q6 = 0.0;

float q1ref = 0.0;
float q2ref = 0.0;
float q3ref = 0.0;
float q4ref = 0.0;
float q5ref = 0.0;
float q6ref = 0.0;

//le seguenti variabili indicano la dimensione dei link
float L = 100;
float D = 60;
float Lmin = 35;

//la variabile TT indica l'autovalore del sistema a tempo discreto
float TT = -0.04;
//la variabile "numRobot" è utilizzata per indicare quale robot rappresentare a schermo
int numRobot = 0;
//la variabile "numGiunto" è utilizzata per indicare quale giunto selezionare per poi farlo variare
int numGiunto = 1;
//la variabile "SdR" è utilizzata per far apparire o scomparire il sistema di riferimento associato ad ogni giunto
int SdR = 0;

int[] tipoDiGiunto = new int[3];

//le seguenti liste tengono traccia dei valori passati e presenti delle variabili di giunto q per rappresentarle sull'oscilliscopio
FloatList andamento_q1;
FloatList andamento_q2;
FloatList andamento_q3;
FloatList andamento_q4;
FloatList andamento_q5;
FloatList andamento_q6;

void setup() {
  size(900,700,P3D);
  background(#6FB2C4);
  directionalLight(126,126,126,0,0,0);
  fill(#F2CB2E);
  
  //inizializzazione dell'array che tiene conto del tipo di giunto (solo per i primi 3 giunti)
  for(int i = 0; i < 3; i++) {
    tipoDiGiunto[i] = 0;        //se tipoDiGiunto = 0 -> giunto ROTOIDALE altrimenti se tipoDiGiunto = 1 -> giunto PRISMATICO
  }
  //inizializzazione delle liste contenente i valori delle variabili di giunto, utilizzate per l'oscilloscopio
  andamento_q1 = new FloatList();
  for(int i = 0; i < 400; i++) {
    andamento_q1.append(q1ref);
  }
  andamento_q2 = new FloatList();
  for(int i = 0; i < 400; i++) {
    andamento_q2.append(q2ref);
  }
  andamento_q3 = new FloatList();
  for(int i = 0; i < 400; i++) {
    andamento_q3.append(q3ref);
  }
  andamento_q4 = new FloatList();
  for(int i = 0; i < 400; i++) {
    andamento_q4.append(q4ref);
  }
  andamento_q5 = new FloatList();
  for(int i = 0; i < 400; i++) {
    andamento_q5.append(q5ref);
  }
  andamento_q6 = new FloatList();
  for(int i = 0; i < 400; i++) {
    andamento_q6.append(q6ref);
  }
}

void draw() {
  background(#6FB2C4);
  
  //le suguenti due funzioni sono utilizzate per creare e rappresentare l'andamento delle variabili di giunto sull'oscilloscopio
  oscilloscopio();
  andamenti_variabili_q(andamento_q1, andamento_q2, andamento_q3, andamento_q4, andamento_q5, andamento_q6);
  
  textSize(18);
  fill(255,0,0);
  if(tipoDiGiunto[0] == 1) {
    //il giunto 1 è di tipo PRISMATICO
    text("q1:",10,25);
    text(q1,40,25);
  }
  if(tipoDiGiunto[0] == 0) {
    //il giunto 1 è di tipo ROTOIDALE
    text("q1:",10,25);
    text((q1*180)/PI,40,25);
  }
  
  fill(255,132,0);
  if(tipoDiGiunto[1] == 1) {
    //il giunto 2 è di tipo PRISMATICO
    text("q2:",10,50);
    text(q2,40,50);
  }
  if(tipoDiGiunto[1] == 0) {
    //il giunto 2 è di tipo ROTOIDALE
    text("q2:",10,50);
    text((q2*180)/PI,40,50);
  }
  
  fill(14,77,13);
  if(tipoDiGiunto[2] == 1) {
    //il giunto 3 è di tipo PRISMATICO
    text("q3:",10,75);
    text(q3,40,75);
  }
  if(tipoDiGiunto[2] == 0) {
    //il giunto 3 è di tipo ROTOIDALE
    text("q3:",10,75);
    text((q3*180)/PI,40,75);
  }
  //tutti i successivi giunti sono di tipo ROTOIDALE
  fill(255,0,200);
  text("q4:",110,25);
  text((q4*180)/PI,140,25);
  
  fill(0,0,255);
  text("q5:",110,50);
  text((q5*180)/PI,140,50);
  
  fill(142,135,0);
  text("q6:",110,75);
  text((q6*180)/PI,140,75);
  
  fill(0);
  text("TT:",10,100);
  text(TT,35,100);
  
  //le seguenti istruzioni permettono di rappresentare a schermo il nome del robot selezionato
  textSize(18);
  if(numRobot == 1) {
    text("Cartesiano",400,25);
  }
  if(numRobot == 2) {
    text("Cilindrico",400,25);
  }
  if(numRobot == 3) {
    text("Scara",400,25);
  }
  if(numRobot == 4) {
    text("Sferico di 1°tipo",400,25);
  }
  if(numRobot == 5) {
    text("Sferico di 2°tipo",400,25);
  }
  if(numRobot == 6) {
    text("Antropomorfo",400,25);
  }
  
  //spostamento dell'origine del sistema di riferimento in un altro punto della finestra di lavoro
  translate(200,450);
  
  //le due seguenti funzioni sono utilizzate per ruotare la visuale del robot
  //la rotazione lungo l'asse Y è con segno negativo perchè quest'ultimo è positivo verso il basso
  rotateY(-angoloY);
  rotateX(angoloX);
  //con la successiva rotazione si porta l'asse Z ad avere direzione verticale con verso positivo in alto
  rotateX(PI/2);
  
  //rappresentazione sulla finestra di lavoro della base su cui poggiano i robot
  stroke(0);
  fill(#F2CB2E);
  box(100,100,15);
  //rappresentazione sulla finestra di lavoro del robot scelto
  strokeWeight(1);
  robot();
  
  //evoluzione delle variabili di giunto
  q1 = q1+TT*(q1-q1ref);
  q2 = q2+TT*(q2-q2ref);
  q3 = q3+TT*(q3-q3ref);
  q4 = q4+TT*(q4-q4ref);
  q5 = q5+TT*(q5-q5ref);
  q6 = q6+TT*(q6-q6ref);
}

void robot() {
  //funzione utilizzata per la realizzazione del robot scelto tramite la variabile "numRobot"
  if(numRobot == 1) {
    //progettazione robot CARTESIANO+POLSO SFERICO
    link(0,q1,-PI/2,0,1);
    link(-PI/2,q2,-PI/2,0,2);
    link(0,q3,0,0,3);
    link(q4,Lmin,-PI/2,0,4);
    link(q5,0,PI/2,0,5);
    link(q6,Lmin,0,0,6);
  }
  else if(numRobot == 2) {
    //progettazione robot CILINDRICO+POLSO SFERICO
    link(q1,L,0,0,1);
    link(0,q2,-PI/2,0,2);
    link(0,q3,0,0,3);
    link(q4,Lmin,-PI/2,0,4);
    link(q5,0,PI/2,0,5);
    link(q6,Lmin,0,0,6);
  }
  else if(numRobot == 3) {
    //progettazione robot SCARA+POLSO SFERICO
    link(q1,L,0,D,1);
    link(q2,L,PI,D,2);
    link(0,q3,0,0,3);
    link(q4,Lmin,-PI/2,0,4);
    link(q5,0,PI/2,0,5);
    link(q6,Lmin,0,0,6);
  }
  else if(numRobot == 4) {
    //progettazione robot SFERICO DI 1°TIPO+POLSO SFERICO
    link(q1,L,PI/2,0,1);
    link(q2,0,PI/2,L,2);
    link(0,q3,0,0,3);
    link(q4,Lmin,-PI/2,0,4);
    link(q5,0,PI/2,0,5);
    link(q6,Lmin,0,0,6);
  }
  else if(numRobot == 5) {
    //progettazione robot SFERICO DI 2°TIPO+POLSO SFERICO
    link(q1,L,-PI/2,0,1);
    link(q2,L,PI/2,0,2);
    link(0,q3,0,0,3);
    link(q4,Lmin,-PI/2,0,4);
    link(q5,0,PI/2,0,5);
    link(q6,Lmin,0,0,6);
  }
  else if(numRobot == 6) {
    //progettazione robot ANTROPOMORFO
    link(q1,L,PI/2,0,1);
    link(q2,0,0,L,2);
    link(q3,0,PI/2,0,3);
    link(q4,Lmin,-PI/2,0,4);
    link(q5,0,PI/2,0,5);
    link(q6,Lmin,0,0,6);
  }
}

//l'ultimo parametro è in numero intero che indica il numero di giunto che si sta realizzando (usato insieme alle altre variabili per indicare
//se il giunto in esame è prismatico o rotoidale
void link(float theta, float d, float alpha, float a, int valoreGiunto) {
  //la funzione seguente serve per realizzare i singoli link del robot
  //eseguire prima operazioni lungo l'asse Z
  rotateZ(theta);
  
  if(SdR == 1) {
    SistemaDiRiferimento();
  }
  
  if(valoreGiunto == 1) {
    if(tipoDiGiunto[0] == 0) {
      //giunto di tipo rotoidale
      sphere(12);
    }
    else {
      //giunto di tipo prismatico
      fill(0);
      box(20,20,20);
      fill(#F2CB2E);
    }
  }
  else if(valoreGiunto == 2) {
    if(tipoDiGiunto[1] == 0) {
      //giunto di tipo rotoidale
      sphere(12);
    }
    else {
      //giunto di tipo prismatico
      fill(0);
      box(20,20,20);
      fill(#F2CB2E);
    }
  }
  else if(valoreGiunto == 3) {
    if(tipoDiGiunto[2] == 0) {
      //giunto di tipo rotoidale
      sphere(12);
    }
    else {
      //giunto di tipo prismatico
      fill(0);
      box(20,20,20);
      fill(#F2CB2E);
    }
  }
  else {
    sphere(12);
  }
  
  translate(0,0,d/2);
  box(15,15,d);
  translate(0,0,d/2);
  
  //eseguo poi operazioni lungo l'asse X
  rotateX(alpha);
  
  sphere(12);
  
  translate(a/2,0,0);
  box(a,15,15);
  translate(a/2,0,0);
}

void SistemaDiRiferimento() {
  //ASSE X
  stroke(255,0,0);
  line(0,0,0,100,0,0);
  translate(100,0,0);
  fill(255,0,0);
  textSize(15);
  text("x",0,0);
  translate(-100,0,0);
  
  //ASSE Y
  stroke(0,255,0);
  line(0,0,0,0,100,0);
  translate(0,100,0);
  fill(0,255,0);
  textSize(15);
  text("y",0,0);
  translate(0,-100,0);
  
  //ASSE Z
  stroke(0,0,255);
  line(0,0,0,0,0,100);
  translate(0,0,100);
  fill(0,0,255);
  textSize(15);
  text("z",0,0);
  translate(0,0,-100);
  
  stroke(0);
  fill(#F2CB2E);
}

//Con le due successive funzioni viene calcolato l'angolo usato per la visualizzazione del robot nello spazio
void mousePressed() {
  //con questa funzione si tiene conto del fatto che si clicca con il pulsante del mouse
  angoloXp = angoloX+(PI*mouseY)/float(500);
  angoloYp = angoloY+(PI*mouseX)/float(500);
}
void mouseDragged() {
  //con questa funzione si tiene conto del tempo in cui tengo premuto il pulsante del mouse
  angoloX = angoloXp-(PI*mouseY)/float(500);
  angoloY = angoloYp-(PI*mouseX)/float(500);
}

void keyPressed() {
  float incremento = 1;
  
  //premento il tasto '0' le variabili di riferimento q vengono resettate
  if(keyCode == '0') {
    q4ref = q5ref = q6ref = 0;
    if(tipoDiGiunto[0] == 0) {
      q1ref = 0;
    }
    if(tipoDiGiunto[0] == 1) {
      q1ref = Lmin;
    }
    if(tipoDiGiunto[1] == 0) {
      q2ref = 0;
    }
    if(tipoDiGiunto[1] == 1) {
      q2ref = Lmin;
    }
    if(tipoDiGiunto[2] == 0) {
      q3ref = 0;
    }
    if(tipoDiGiunto[2] == 1) {
      q3ref = Lmin;
    }
  }
  //premendo il tasto '9' si fanno apparire e scomparire i sistemi di riferimento associati ad ogni giunto
  if(keyCode == '9') {
    if(SdR == 0) {
      SdR = 1;
    }
    else {
      SdR = 0;
    }
  }
  //premendo uno dei seguenti tasti si seleziona il giunto da esaminare e/o variare
  if(keyCode == 'A') {
    numGiunto = 1;
  }
  if(keyCode == 'S') {
    numGiunto = 2;
  }
  if(keyCode == 'D') {
    numGiunto = 3;
  }
  if(keyCode == 'F') {
    numGiunto = 4;
  }
  if(keyCode == 'G') {
    numGiunto = 5;
  }
  if(keyCode == 'H') {
    numGiunto = 6;
  }
  //le suguenti istruzioni sono utilizzate per far incrementare/decrementare il valore del giunto precedentemente selezionato
  if(keyCode == LEFT) {
    if(numGiunto == 1) {
      if(tipoDiGiunto[0] == 1 & q1ref <= 20) {
        //vincolo dimensionale sul giunto 1 di tipo prismatico
        q1ref = 20;
      }
      else {
        if(tipoDiGiunto[0] == 1) {
          q1ref = q1ref - incremento;
        }
        else {
          q1ref = q1ref - incremento/4;
        }
      }
    }
    else if(numGiunto == 2) {
      if(tipoDiGiunto[1] == 1 & q2ref <= 20) {
        //vincolo dimensionale sul giunto 2 di tipo prismatico
        q2ref = 20;
      }
      else {
        if(tipoDiGiunto[1] == 1) {
          q2ref = q2ref - incremento;
        }
        else {
          q2ref = q2ref - incremento/4;
        }
      }
    }
    else if(numGiunto == 3) {
      if(tipoDiGiunto[2] == 1 & q3ref <= 20) {
        //vincolo dimensionale sul giunto 3 di tipo prismatico
        q3ref = 20;
      }
      else {
        if(tipoDiGiunto[2] == 1) {
          q3ref = q3ref - incremento;
        }
        else {
          q3ref = q3ref - incremento/4;
        }
      }
    }
    else if(numGiunto == 4) {
      q4ref = q4ref - incremento/4;
    }
    else if(numGiunto == 5) {
      q5ref = q5ref - incremento/4;
    }
    else if(numGiunto == 6) {
      q6ref = q6ref - incremento/4;
    }
  }
  if(keyCode == RIGHT) {
    if(numGiunto == 1) {
      if(tipoDiGiunto[0] == 1) {
        q1ref = q1ref + incremento;
      }
      else {
        q1ref = q1ref + incremento/4;
      }
    }
    else if(numGiunto == 2) {
      if(tipoDiGiunto[1] == 1) {
        q2ref = q2ref + incremento;
      }
      else {
        q2ref = q2ref + incremento/4;
      }
    }
    else if(numGiunto == 3) {
      if(tipoDiGiunto[2] == 1) {
        q3ref = q3ref + incremento;
      }
      else {
        q3ref = q3ref + incremento/4;
      }
    }
    else if(numGiunto == 4) {
      q4ref = q4ref + incremento/4;
    }
    else if(numGiunto == 5) {
      q5ref = q5ref + incremento/4;
    }
    else if(numGiunto == 6) {
      q6ref = q6ref + incremento/4;
    }
  }
  //con le seguenti istruzioni si va a selezionare il robot da rappresentare sulla finestra di lavoro
  if(keyCode == '1') {
    //robot CARTESIANO + POLSO SFERICO
    numRobot = 1;
    tipoDiGiunto[0] = 1;
    tipoDiGiunto[1] = 1;
    tipoDiGiunto[2] = 1;
    //inizializzazione delle grandezze standard per i link ed i giunti
    q1ref = q2ref = q3ref = Lmin;
    q4ref = q5ref = q6ref = 0;
  }
  else if(keyCode == '2') {
    //robot CILINDRICO + POLSO SFERICO
    numRobot = 2;
    tipoDiGiunto[0] = 0;
    tipoDiGiunto[1] = 1;
    tipoDiGiunto[2] = 1;
    //inizializzazione delle grandezze standard per i link ed i giunti
    q2ref = q3ref = Lmin;
    q1ref = q4ref = q5ref = q6ref = 0;
  }
  else if(keyCode == '3') {
    //robot SCARA + POLSO SFERICO
    numRobot = 3;
    tipoDiGiunto[0] = 0;
    tipoDiGiunto[1] = 0;
    tipoDiGiunto[2] = 1;
    //inizializzazione delle grandezze standard per i link ed i giunti
    q3ref = Lmin;
    q1ref = q2ref = q4ref = q5ref = q6ref = 0;
  }
  else if(keyCode == '4') {
    //robot SFERICO DI 1°TIPO + POLSO SFERICO
    numRobot = 4;
    tipoDiGiunto[0] = 0;
    tipoDiGiunto[1] = 0;
    tipoDiGiunto[2] = 1;
    //inizializzazione delle grandezze standard per i link ed i giunti
    q3ref = Lmin;
    q1ref = q2ref = q4ref = q5ref = q6ref = 0;
  }
  else if(keyCode == '5') {
    //robot SFERICO DI 2°TIPO + POLSO SFERICO
    numRobot = 5;
    tipoDiGiunto[0] = 0;
    tipoDiGiunto[1] = 0;
    tipoDiGiunto[2] = 1;
    //inizializzazione delle grandezze standard per i link ed i giunti
    q3ref = Lmin;
    q1ref = q2ref = q4ref = q5ref = q6ref = 0;
  }
  else if(keyCode == '6') {
    //robot ANTROPOMORFO + POLSO SFERICO
    numRobot = 6;
    tipoDiGiunto[0] = 0;
    tipoDiGiunto[1] = 0;
    tipoDiGiunto[2] = 0;
    //inizializzazione delle grandezze standard per i link ed i giunti
    q1ref = q2ref = q3ref = q4ref = q5ref = q6ref = 0;
  }
  //con le seguenti funzioni si può far variare la variabile TT
  if(keyCode == UP) {
    if(TT < 0.0) {
      TT = TT + 0.01;
    }
    else {
      TT = -0.04;
    }
  }
  else if(keyCode == DOWN) {
    if(TT > -1) {
      TT = TT - 0.01;
    }
    else {
      TT = -0.04;
    }
  }
}

//la seguente funzione permette di disegnare sulla finestra di lavoro lo sfondo dell'oscilloscopio
void oscilloscopio() {
  strokeWeight(1);
  stroke(0);
  fill(255);
  //nella funzione "rect" i primi due parametri sono le coordinate di partenza mentre gli ultimi due indicano la quantità di cui spostarsi
  rect(500,100,400,500);
  //nella funzione "line" i primi due parametri sono le coordinate di partenza mentre gli ultimi due indicano le coordinate di arrivo
  line(500,600,900,600);
  line(500,550,900,550);
  line(500,500,900,500);
  line(500,450,900,450);
  line(500,400,900,400);
  line(500,350,900,350);
  line(500,300,900,300);
  line(500,250,900,250);
  line(500,200,900,200);
  line(500,150,900,150);
  
  textSize(20);
  fill(0);
  //asse Y del grafico
  text("0",460,350);
  text("50",460,300);
  text("100",460,250);
  text("150",460,200);
  text("200",460,150);
  text("250",460,100);
  text("-50",460,400);
  text("-100",460,450);
  text("-150",460,500);
  text("-200",460,550);
  text("-250",460,600);
  
  text("asse Y: [m] e [gradi]",550,40);
  text("asse X: [s]",550,60);
}

//la seguente funzione permette di rappresentare sulla finestra di lavoro e più precisamente nell'area dell'oscilloscopio gli andamenti delle 6 variabili di giunto
void andamenti_variabili_q(FloatList lista1, FloatList lista2, FloatList lista3, FloatList lista4, FloatList lista5, FloatList lista6) {
  strokeWeight(2);
  
  //variabile di giunto 1
  stroke(255,0,0);
  float val_q1 = q1;
  
  if(tipoDiGiunto[0] == 1) {
    val_q1 = q1;
  }
  else if(tipoDiGiunto[0] == 0) {
    val_q1 = (q1*180)/PI;
  }
  
  for(int i = 0; i < 399; i++) {
    float val_q1_next = lista1.get(i+1);
    lista1.set(i+1,val_q1);
    //la coordinata 350 nella condizione successiva indica la coordinata Y del valore 0
    if(350-val_q1_next < 100 || 350-val_q1_next > 600) {
      noStroke();
    }
    else {
      line(900-i,350-val_q1,899-i,350-val_q1_next);
      val_q1 = val_q1_next;
    }
  }
  
  //variabile di giunto 2
  stroke(255,132,0);
  float val_q2 = q2;
  
  if(tipoDiGiunto[1] == 1) {
    val_q2 = q2;
  }
  else if(tipoDiGiunto[1] == 0) {
    val_q2 = (q2*180)/PI;
  }
  
  for(int i = 0; i < 399; i++) {
    float val_q2_next = lista2.get(i+1);
    lista2.set(i+1,val_q2);
    if(350-val_q2_next < 100 || 350-val_q2_next > 600) {
      noStroke();
    }
    else {
      line(900-i,350-val_q2,899-i,350-val_q2_next);
      val_q2 = val_q2_next;
    }
  }
  
  //variabile di giunto 3
  stroke(14,77,13);
  float val_q3 = q3;
  
  if(tipoDiGiunto[2] == 1) {
    val_q3 = q3;
  }
  else if(tipoDiGiunto[2] == 0) {
    val_q3 = (q3*180)/PI;
  }
  
  for(int i = 0; i < 399; i++) {
    float val_q3_next = lista3.get(i+1);
    lista3.set(i+1,val_q3);
    if(350-val_q3_next < 100 || 350-val_q3_next > 600) {
      noStroke();
    }
    else {
      line(900-i,350-val_q3,899-i,350-val_q3_next);
      val_q3 = val_q3_next;
    }
  }
  
  //variabile di giunto 4 è di tipo rotoidale sempre
  stroke(255,0,200);
  float val_q4 = q4;
  
  val_q4 = (val_q4*180)/PI;
  
  for(int i = 0; i < 399; i++) {
    float val_q4_next = lista4.get(i+1);
    lista4.set(i+1,val_q4);
    if(350-val_q4_next < 100 || 350-val_q4_next > 600) {
      noStroke();
    }
    else {
      line(900-i,350-val_q4,899-i,350-val_q4_next);
      val_q4 = val_q4_next;
    }
  }
  
  //variabile di giunto 5 è di tipo rotoidale sempre
  stroke(0,0,255);
  float val_q5 = q5;
  
  val_q5 = (val_q5*180)/PI;
  
  for(int i = 0; i < 399; i++) {
    float val_q5_next = lista5.get(i+1);
    lista5.set(i+1,val_q5);
    if(350-val_q5_next < 100 || 350-val_q5_next > 600) {
      noStroke();
    }
    else {
      line(900-i,350-val_q5,899-i,350-val_q5_next);
      val_q5 = val_q5_next;
    }
  }
  
  //variabile di giunto 6 è di tipo rotoidale sempre
  stroke(142,135,0);
  float val_q6 = q6;
  
  val_q6 = (val_q6*180)/PI;
  
  for(int i = 0; i < 399; i++) {
    float val_q6_next = lista6.get(i+1);
    lista6.set(i+1,val_q6);
    if(350-val_q6_next < 100 || 350-val_q6_next > 600) {
      noStroke();
    }
    else {
      line(900-i,350-val_q6,899-i,350-val_q6_next);
      val_q6 = val_q6_next;
    }
  }
}
