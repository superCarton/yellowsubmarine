import javax.swing.JOptionPane;


// infos
int fps = 25;
int rapportMetrePix = 10;
int profondeurMetres = 5000;
int tailleSolMetre = 100;
int tciel = 500;
int w = 8000;
int h = profondeurMetres+tailleSolMetre+tciel;
int profondeurpix = profondeurMetres/rapportMetrePix;
int tsolpix = tailleSolMetre/rapportMetrePix;
int tcielpix = tciel/rapportMetrePix;
int wpix = w/rapportMetrePix;
int hpix = h/rapportMetrePix;


// sous marin
int largeur = 125;
int hauteur = 11;
int tgyroscope = 20;
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
double g=10; // pesanteur terre en m/sÂ² 
//Poussé Archimède
double PA=mf*g;
int mvide= 9999000; // masse Ã  vide (kg)
double mbalast= 1000.0;
double vremplissagebalast= 0.0; // si positif, se remplit, sinon, se vide
double mbalastMax= 2000.0;
double mtotal=mvide+mbalast;
double poids=mtotal*g;
double f=1; //Frottement
double poids=mtotal*g; 
double frottement=1; //Frottement
double Ph = 0;
double Pv = (int)(PA - poids);
// obstacles
int obsw = 50;
int obsh = 70;
int obsx = 400;

// etats
double[] Xn = {w/2, 0, -tciel, 0};
double[] P = {Ph,Pv};
double[][] Ad = {{1,0.04,0,0},{0,1,0,0},{0,0,1,0.04},{0,0,0,1}};
double[][] Bd = {{0.080008*10*exp(-9),0}
                  ,{4.0004*10*exp(-9),0}
                   ,{0,0.080008*10*exp(-9)}
                    ,{0,4.0004*10*exp(-9)}};
double[][] Ad = {{1,0.0362535,0,0},{0,0.8187144,0,0},{0,0,1,0.0362535},{0,0,0,0.8187144}};
double[][] Bd = {{0.0749300*10*exp(-9),0}
                  ,{3.6257125*10*exp(-9),0}
                   ,{0,0.0749300*10*exp(-9)}
                    ,{0,3.6257125*10*exp(-9)}};

void setup(){
  
  // fenetre
  size(wpix,hpix);
  
  frameRate(fps);
}

void draw(){
  
  nettoyer();
  smooth();
  nouvelEtat();
  afficher();

}

/**************** GETTERS *******************/

/*double getX(){
  return Xn[2];
}

double getY(){
  
}*/

/**************** MAJ MATRICE ETAT *********************/

void nouvelEtat(){

  mbalast+=vremplissagebalast;
  if (mbalast>mbalastMax){
    vremplissagebalast=0;
    mbalast=mbalastMax;
  } else if (mbalast<0) {
    vremplissagebalast=0;
    mbalast = 0;
  }
    
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
  
  println(" PV :" + Pv);
  
  if (Xn[2]>(-tciel)) {
    Xn[2] = -tciel;
    Xn[3] = 0;
  }
  
  if (Xn[2]<(-(tciel+profondeurMetres))){
    JOptionPane.showMessageDialog(this, "You lose");
    reset();
  }
  
  
  
  print("X : " + (int)Xn[0] + " ; X. = " + (int)Xn[1] + " ; Y = " + (int)Xn[2] + " ; Y. = " + (int)Xn[3] + " --- ");
  print("MBalast : " + mbalast + " ; VRemplissageBalast = " + vremplissagebalast);
  print("Poids : " + Pv);
  print("Xn[3] : " + Xn[3]);
  print(";   M balast : " + mbalast);
  println();
  
}



/*************** AFFICHAGE ********************/

void nettoyer(){
  
  // eau bleu foncé
  background(38,164,248);
  
  // ciel bleu clair
  fill(219, 239, 234);
  rect(0, 0, wpix, tcielpix);
  
  // sol marron
  fill(153, 76, 0);
  rect(0, hpix-tsolpix, wpix, tsolpix);
  
  // obstacl0e
  /*fill(238, 180, 123);
  rect(obsx, h-obsh, obsw, obsh);*/
  noFill();
  
}


void afficher(){
  
  fill(255, 255, 0);
  rect((int)Xn[0]/rapportMetrePix, -(int)Xn[2]/rapportMetrePix, (int)longueurSousMarin, (int)hauteurSousMarin);
  noFill();
  
}


/*************** COMMANDES ********************/

void keyPressed()
  {
    switch (keyCode){
      case UP : up(); break;
      case DOWN : down(); break;
      case LEFT : left(); break;
      case RIGHT : right(); break;
      case 32 : space(); break;
    }
}


void up(){
  vremplissagebalast-=(1.0/(double)fps);
}

void down(){
  vremplissagebalast+=(1.0/(double)fps);
}

void right(){
 // x++;
 Ph+=(50.0/(double)fps);
}

void left(){
  //x--;
  Ph-=(50.0/(double)fps);
}

void space(){
  vremplissagebalast=0;
}
/**************** reset ****************/
void reset(){
  Xn[0]=w/2;
  Xn[1]= 0;
  Xn[2] =-tciel;
  Xn[3]=0;
  mbalast= 1000.0;
  vremplissagebalast= 0.0;
}
