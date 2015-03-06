// infos
int fps = 100;
int tciel = 50;
int w = 800;
int h = 400;

// sous marin
int largeur = 120;
int hauteur = 70;
int tgyroscope = 20;
int x = 0;
int y = tciel - tgyroscope;
PImage ssmarin;

// obstacles
int obsw = 50;
int obsh = 70;
int obsx = 400;

// etats
int[] Xn = {x, 0, y, 0};
int[][] Ad = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};

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
  image(ssmarin, Xn[0], Xn[2], largeur, hauteur);
}

void nettoyer(){
  
  // eau
  background(38,164,248);
  
  // ciel
  fill(219, 239, 234);
  rect(0, 0, w, tciel);
  
  // obstacle
  fill(238, 180, 123);
  rect(obsx, h-obsh, obsw, obsh);
  noFill();
  
}

void nouvelEtat(){
 
  /* multiplication de Xn par Ad */
  for (int i=0; i<4; i++){ // pour chaque valeur de Xn
    int v = 0;
    for (int j=0; j<4; j++){ // on multiplie et additionne
      v += Xn[i] * Ad[i][j];
    }
    Xn[i] = v;
  }
  
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
  y--;
}

void down(){
  y++;
}

void right(){
  x++;
}

void left(){
  x--;
}
