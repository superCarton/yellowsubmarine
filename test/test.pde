// infos
int fps = 1;
int tciel = 50;
int w = 800;
int h = 400;

// sous marin
int largeur = 125;
int hauteur = 11;
int tgyroscope = 20;
int x = 0;
int y = tciel;
PImage ssmarin;

// données réel
double longueurSousMarin = 100;
double largeurSousMarin = 10;
double hauteurSousMarin = 10;
double volume = longueurSousMarin*largeurSousMarin*hauteurSousMarin;
int masseVolumiqueEau=1000;
//masse d'eau déplacée
double mf=volume*masseVolumiqueEau;
double g=9.8; // pesanteur terre en m/sÂ² 
//Poussé Archimède
double PA=mf*g;
int mvide= 9999000; // masse Ã  vide (kg)
int mbalast= 0;
int mbalastMax= 2000;
int mtotal=mvide+mbalast;
double poids=mtotal*g;
double f=1; //Frottement
double Ph = 0;
double Pv = (int)(PA - poids);
// obstacles
int obsw = 50;
int obsh = 70;
int obsx = 400;

// etats
double[] Xn = {x, 0, y, 0};
double[] P = {Ph,Pv};
double[][] Ad = {{1,0.04,0,0},{0,1,0,0},{0,0,1,0.04},{0,0,0,1}};
double[][] Bd = {{0.080008*10*exp(-9),0}
                  ,{4.0004*10*exp(-9),0}
                   ,{0,0.080008*10*exp(-9)}
                    ,{0,4.0004*10*exp(-9)}};
//double[][] A = {{0,1,0,0},{0,-f/mtotal,0,0},{0,0,0,1},{0,0,0,-f/mtotal}};
//double[][] B = {{0,0},{1/mtotal,0},{0,0},{0,1/mtotal}};
void setup(){
  
  // fenetre
  size(w,h);
  nettoyer();
  
  ssmarin = loadImage("sousmarin.png");
  
  frameRate(fps);
}

void draw(){
  
  nettoyer();
  smooth();
  nouvelEtat();
 // image(ssmarin, (int)Xn[0], (int)Xn[2], largeur, hauteur);
 fill(219, 100, 234);
  rect((int)Xn[0], (int)Xn[2], (int)longueurSousMarin, (int)hauteurSousMarin);
}

void nettoyer(){
  
  // eau
  background(38,164,248);
  
  // ciel
  fill(219, 239, 234);
  rect(0, 0, w, tciel);
  
  // obstacl0e
  fill(238, 180, 123);
  rect(obsx, h-obsh, obsw, obsh);
  noFill();
  
}

void nouvelEtat(){

  mtotal=mvide+mbalast;
  poids=mtotal*g;
  Pv = PA - poids;
  P[0] = Ph;
  P[1] = Pv;
  double[] Xntmp = Xn;
  /* multiplication de Xn par Ad */
  for (int i=0; i<4; i++){ // pour chaque valeur de Xn
    double v = 0;
    for (int j=0; j<4; j++){ // on multiplie et additionne
      v += Ad[i][j]*Xntmp[j];
    }
    Xn[i] = v;
  }
  for (int i=0; i<4; i++){ // pour chaque valeur de Xn
    double v = 0;
    for (int j=0; j<2; j++){ // on multiplie et additionne
      v += Bd[i][j]*P[j];
    }
    Xn[i] += v;
  }
  
  println("X : " + Xn[0] + " ; X. = " + Xn[1] + " ; Y = " + Xn[2] + " ; Y. = " + Xn[3]);
}

void keyPressed()
  {
    switch (keyCode){
      case UP : up(); break;
      case DOWN : down(); break;
      case LEFT : left(); break;
      case RIGHT : right(); break;
    }
}

void up(){
  if (mbalast>0){
    mbalast-=100;
  }
}

void down(){
   if (mbalast<mbalastMax){
    mbalast+=100;
  }
}

void right(){
  x++;
}

void left(){
  x--;
}
