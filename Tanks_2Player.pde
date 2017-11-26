  boolean isE=false, isS=false, isD=false, isF=false, isQ=false;
  boolean isUp=false, isRight=false, isLeft=false, isDown=false, isM=false;
  String Winner="none";
  int resetTimer=-1,shakeTimer=0,powTimer=60,score1,score2,scene=1;
  Tank tank1, tank2;
  color backC = color(255);
  ArrayList<PowerUp> powList = new ArrayList<PowerUp>();
  ArrayList<Shot> shotList = new ArrayList<Shot>();
  ArrayList<Wall> wallList = new ArrayList<Wall>();
  ArrayList<Wall> level1w = new ArrayList<Wall>();ArrayList<Wall> level2w = new ArrayList<Wall>();ArrayList<Wall> level3w = new ArrayList<Wall>();ArrayList<Wall> levelRw = new ArrayList<Wall>();
  Level level1;Level level2;Level level3;Level levelR;
  void setup() {
    //size(500,500,P2D);
    fullScreen(P2D);
    frameRate(60);
    smooth(8);
    level1w.add(new Wall(0,height*0.25,width*1,30,0,false));
    level1w.add(new Wall(width*0.9,height*0.75,width/2,30,0,false));
    level1 = new Level(level1w);
    
    level2w.add(new Wall(width*0.25,height*0.5,50,height*0.7,0,false));
    level2w.add(new Wall(width*0.75,height*0.5,50,height*0.7,0,false));
    level2 = new Level(level2w);
  
    level3w.add(new Wall(width*0.25,height*0.75,50,height*0.6,0,false));
    level3w.add(new Wall(width*0.75,height*0.25,50,height*0.6,0,false));
    level3 = new Level(level3w);

    reset();
    
  }
  void draw() { if(scene==1) { scene1(); } else { if(scene==2) { scene2(); } } }
  void scene1(){
    background(255);
    textAlign(CENTER,TOP);fill(0);stroke(0);textSize(100);
    text("Tanks 2Player",width/2,0); textSize(50);
    text("By Karl Hedberg",width/2,height*0.12);rectMode(CENTER);fill(255);stroke(0);
    // BUTTON 1
    if(rectCol(mouseX,mouseY,1,1,width/2-250/2,height/2-125/2,250,125)){fill(255,255,0);} else {fill(0,255,255);}
    rect(width/2,height/2,250,125);fill(0);textAlign(CENTER,CENTER);
    text("Play",width/2,height/2);
    //BUTTON 2
    if(rectCol(mouseX,mouseY,1,1,width/2-250/2,height*0.75-125/2,250,125)){fill(255,255,0);} else {fill(0,255,255);}
    rect(width/2,height*0.75,250,125);fill(0);textAlign(CENTER,CENTER);
    text("Exit",width/2,height*0.75);
    
    if(rectCol(mouseX,mouseY,1,1,width/2-250/2,height/2-125/2,250,125)&&mousePressed){scene=2;}
    if(rectCol(mouseX,mouseY,1,1,width/2-250/2,height*0.75-125/2,250,125)&&mousePressed){exit();}
  }
  void scene2(){
    //reset();
    background(backC);
    doStuff();
    for (int i = 0; i < wallList.size(); i++) {if(wallList.get(i).working==false&&!wallList.get(i).important){wallList.remove(i);}}//walls
    for (int i = 0; i < wallList.size(); i++) {wallList.get(i).cycle();}//walls
    tank1.cycle();
    tank2.cycle();
    for (int i = 0; i < shotList.size(); i++) {shotList.get(i).cycle();}//shots
    for (int i = 0; i < powList.size(); i++) {powList.get(i).cycle();}//power-ups
    drawScore();
    if(Winner!="none"){printWinner();}
    button();
  }
  void button() {
    if(rectCol(mouseX,mouseY,1,1,width*0.99-20/2,height*0.02-20/2,20,20)){fill(255,255,0);} else {fill(0,255,255);}
    rect(width*0.99,height*0.02,20,20);fill(0);strokeWeight(3);point(width*0.99,height*0.02);point(width*0.986,height*0.02);point(width*0.994,height*0.02);
    strokeWeight(1);
    if(rectCol(mouseX,mouseY,1,1,width*0.99-20/2,height*0.02-20/2,20,20)&&mousePressed){scene=1;}
  }
  boolean predictShot(float range,float Rots,float Xs, float Ys,color ofColors,String type,boolean forever){
    Shot s=new Shot(tank1.X,tank1.Y,Rots,type,10,10,0,0,ofColors);
    float bounces=0;
    ArrayList<Vector> pos = new ArrayList<Vector>();
    for(int i=0; i<range;i++){
      s.cycle();
      pos.add(new Vector(s.X,s.Y));
      if(s.HP<1){break;}
    }
    //color Cs=0;
    for(int q=1; q<pos.size();q++){
      //stroke(Cs);
      //line(pos.get(q-1).X,pos.get(q-1).Y,pos.get(q).X,pos.get(q).Y);
      //if(Cs==0){Cs=255;} else {Cs=0;}
      if( rectCol(pos.get(q-1).X-5,pos.get(q-1).Y-5,10,10,tank2.X-tank2.XSize,tank2.Y-tank2.YSize,tank2.XSize,tank2.YSize) ){
        if(!forever){return true;}
      }
      
    }
    return false;
  }
  void shake(){
    if(shakeTimer>0){
      translate(random(-2,2),random(-2,2));
      shakeTimer--;
    }
  }

  void powSpawn () {
    String[] s = {"SEE","CLUSTERBOMB","TRIPLESHOT","MACHINE"};
    //String[] s = {"MACHINE"};
    if( powTimer < 1 && powList.size() < 3 ) {
      powList.add(new PowerUp(s[int(random(s.length))],random(0,width),random(0,height)));
      powTimer = int(random(500,800));
    } else {powTimer--;}
  }
  void drawScore(){
    textAlign(CENTER, TOP);
    textSize(50);
    fill(125);
    text(score1 + "                                                                   " + score2, width/2, height*0.1);
  }
  void doStuff() {
    
    powSpawn();
    shake();
    if (Winner=="none") {
      chooseWinner();
    }
    if (Winner!="none") {
      //printWinner();
      if (resetTimer==-1) {
        resetTimer=150;
        shakeTimer=resetTimer/4;
      }
    }
    if (resetTimer==0) {
      reset();
      resetTimer=-1;
    }
    if (resetTimer!=-1) {
      resetTimer--;
    }
  
  }
  void printWinner() {
    textAlign(CENTER, TOP);
    textSize(50);
    fill(255/2);
    text("The Winner is: " + Winner + "!", width/2, height*0.1);
  }
  void chooseWinner() {
    if (tank1.Dead&&!tank2.Dead) {
      Winner = "Tank2";
    } else if (!tank1.Dead&&tank2.Dead) {
      Winner = "Tank1";
    } else if (tank1.Dead&&tank2.Dead) {
      Winner = "Draw";
    } else {
      Winner = "none";
    } // STILL NO WINNER
  }
  void reset() {
    tank1 = new Tank(0, 0, "left");
    tank2 = new  Tank(0, 0, "right");
    shotList = new ArrayList<Shot>();
    wallList = new ArrayList<Wall>();
    powList = new ArrayList<PowerUp>();
    Winner = "none";
    Level[] ls = {level1,level2,level3};
    //loadLevel(ls[int(random(0,ls.length-1))]);
    levelRreset();
    loadLevel(levelR);
    while(checkIfLevelPossible(tank1.X,tank1.Y,"nodraw",0,false)==false){levelRreset();loadLevel(levelR);}
    powTimer=0;
    //while(tank1.insideWall()){tank1.rePosition();}
    //while(tank2.insideWall()){tank2.rePosition();}
    checkIfLevelPossible(tank2.X,tank2.Y,"normal",color(random(255),random(255),random(255)),true);
    checkIfLevelPossible(tank1.X,tank1.Y,"normal",color(random(255),random(255),random(255)),true);
    color haj = color(random(255),random(255),random(255));
    for(int i=0; i<wallList.size();i++){
      wallList.get(i).C+=haj;
    }
  }
  boolean checkIfLevelPossible(float X1,float Y1,String type,color CIS,boolean forever){
    for(int i=0; i<360;i+=10){
      if(predictShot(1000,i,tank1.X,tank1.Y,CIS,type,forever)){return true;}
    }
    return false;
  }
  void loadLevel(Level l) {
    
    wallList = new ArrayList<Wall>();
    for(int i=0; i < l.wList.size(); i++){ // ADD WALLS
      wallList.add(l.wList.get(i));
    }
    
    // ADD THE OUTER WALLS
    wallList.add(new Wall(0, height/2, 20, height,0,true));//topleft to bottomleft
    wallList.add(new Wall(width/2, 0, width, 20,0,true));//topleft to topright
    wallList.add(new Wall(width-0, height/2, 20, height,0,true));// topright to bottomright
    wallList.add(new Wall(width/2, height-0, width, 20,0,true));//from bottomleft to bottomright
    while(tank1.insideWall()){tank1.rePosition();}
    while(tank2.insideWall()){tank2.rePosition();}
  }
  void levelRreset(){
    levelRw = new ArrayList<Wall>();
    float scale;
    float offsetX=random(5000),offsetY=random(5000);
    while(levelRw.size()<100||levelRw.size()>200){
      scale=5;
      levelRw = new ArrayList<Wall>();
      offsetX=random(5000);offsetY=random(5000);
      for (int x=0;x<width;x+=50) {
        for (int y=0; y < height; y+=50) {
          float xCoord = (float)x / width * scale + offsetX;
          float yCoord = (float)y / height * scale + offsetY;
          float sample = noise(xCoord,yCoord);
          sample*=255;
  
          if(sample<100){levelRw.add(new Wall(x,y,50,50,color(sample),false));}
        }
      }
    }
    levelR = new Level(levelRw);
  }
  void keyPressed() {
    if (key=='q'||key=='Q') {isQ=true;}
    if (key=='e'||key=='E') {isE=true;}
    if (key=='s'||key=='S') {isS=true;}
    if (key=='d'||key=='D') {isD=true;}
    if (key=='f'||key=='F') {isF=true;}
    
    if (key=='m'||key=='M') {isM=true;}
    if (key == CODED) {
      if (keyCode == UP) {isUp=true;}
      if (keyCode == RIGHT) {isRight=true;}
      if (keyCode == LEFT) {isLeft=true;}
      if (keyCode == DOWN) {isDown=true;}
    }
  }
  void keyReleased() {
  if (key=='e'||key=='E') {isE=false;}
  if (key=='s'||key=='S') {isS=false;}
  if (key=='d'||key=='D') {isD=false;}
  if (key=='f'||key=='F') {isF=false;}
  if (key=='q'||key=='Q') {isQ=false;}
  if (key=='m'||key=='M') {isM=false;}
  if (key == CODED) {
    if (keyCode == UP) {isUp=false;}
    if (keyCode == RIGHT) {isRight=false;}
    if (keyCode == LEFT) {isLeft=false;}
    if (keyCode == DOWN) {isDown=false;}
  }
}
boolean rectCol(float X1, float Y1, float SX1, float SY1, float X2, float Y2, float SX2, float SY2) {
  if (X1 < X2 +SX2&& X1+SX1 > X2 &&Y1 < Y2+SY2 && Y1+SY1> Y2) {return true;} else return false;}