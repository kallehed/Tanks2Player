class Tank {
  float X,Y,XVel=0,YVel=0,XSize,YSize,Rot=0,RotVel=0,Speed=3,RotSpeed=3;
  float Diag,ShootWait,ShootTime,deadTimer=0;float powerTimer=0, range=0;
  String LR,PowerUp="none";
  boolean Dead=false;
  Tank(float Xs,float Ys,String LRs){
    this.X=Xs; this.Y=Ys;
    this.LR = LRs;this.XSize=40;this.YSize=40;
    this.Diag = sqrt(pow(XSize,2) + pow(YSize,2));
    this.ShootTime=120;

  }
  void cycle(){
    if(!this.Dead){
      this.move();
      this.limitIt();
      this.predictShot(this.range,Rot);
      //if(LR=="left"){for(int i=0;i<360;i++){this.predictShot(this.range,i);}}
      this.getShot();
      this.shoot();
      /*this.Rot = degrees(atan2(mouseY-Y,mouseX-X)); //ROTATES TOWARDS MOUSE
      this.Rot-=90;*/
      this.drawIt();
    } else {
      if(deadTimer==0||deadTimer==5||deadTimer==10){
        this.explode();
      }
      this.drawIt();
      this.deadTimer++;
    }
  }
  void predictShot(float range,float Rots){

    float nX=this.X,nY=this.Y,nRot=Rots;
    ArrayList<Vector> pos = new ArrayList<Vector>();
    for(int i=0; i<range;i++){
      pos.add(new Vector(nX,nY));
      nY += cos(radians(nRot)) * 10;
      nX -= sin(radians(nRot)) * 10;
      for(int is = 0; is<wallList.size();is++){
        Wall w = wallList.get(is);
        if(rectCol(nX-5,nY-5,10,10,w.X-w.XSize/2,w.Y-w.YSize/2,w.XSize,w.YSize)) {

          if(nY-5>w.Y-w.YSize/2&&nY+5<w.Y+w.YSize/2){
            if(nX>w.X){nX=w.X+w.XSize/2+5; nRot=360-nRot;}
            if(nX<w.X){nX=w.X-w.XSize/2-5; nRot=360-nRot;}
          } else {
            if(nY>w.Y){nY=w.Y+w.YSize/2+5;nRot=180-nRot;}
            if(nY<w.Y){nY=w.Y-w.YSize/2-5;nRot=180-nRot;}
          }
        }
      }
      
    }
    color Cs=0;
    for(int q=1; q<pos.size();q++){
      stroke(Cs);
      line(pos.get(q-1).X,pos.get(q-1).Y,pos.get(q).X,pos.get(q).Y);
      if(Cs==0){Cs=255;} else {Cs=0;}
    }
  }
  void explode(){
    color hej=0;
    if(LR=="left"){hej=color(0,255,0);}
    if(LR=="right"){hej=color(0,0,255);}
    for(int in=0;in<360;in+=5){
      
      shotList.add(new Shot(this.X,this.Y,in,"normal",2,5,0,0,hej));
    }
  }
  void getShot(){
    if( (LR=="left"&&!tank2.Dead) || (LR=="right"&&!tank1.Dead) ){
      for(int i = 0; i<shotList.size();i++){
        Shot s = shotList.get(i);
        if(s.HP>0&&s.hurtTimer<1&&rectCol(X-XSize/2,Y-YSize/2,XSize,YSize,s.X-s.Size/2,s.Y-s.Size/2,s.Size,s.Size)){
          this.Dead=true;
          if(this.LR=="left"){score2++;} else if(this.LR=="right"){score1++;}
        }
      }
    }
  }
  void limitIt(){
    for(int i = 0; i<wallList.size();i++){
      Wall w = wallList.get(i);
      if(rectCol(X-XSize/2,Y-YSize/2,XSize,YSize,w.X-w.XSize/2,w.Y-w.YSize/2,w.XSize,w.YSize)){
        
        if(this.Y+this.YSize/2-3>w.Y-w.YSize/2&&this.Y-this.YSize/2+3<w.Y+w.YSize/2){ // IF IT IS ON THE RIGHT SIDE
          if(this.X>w.X){this.X=w.X+w.XSize/2+this.XSize/2;}
          if(this.X<w.X){this.X=w.X-w.XSize/2-this.XSize/2;}
        } else {
          if(this.Y>w.Y){this.Y=w.Y+w.YSize/2+this.YSize/2;}
          if(this.Y<w.Y){this.Y=w.Y-w.YSize/2-this.YSize/2;}
        }
      }
    } // OUT OF BOUNDARIES
    if(X+XSize/2>width){this.rePosition();}
    if(X-XSize/2<0){this.rePosition();}
    if(Y+YSize/2>height){this.rePosition();}
    if(Y-YSize/2<0){this.rePosition();}
  }
  void rePosition(){
    if(LR=="left") {
      X = random(10,width/2);Y = random(20,height-20);Rot=random(0,360);
    }
    if(LR=="right") {
      X = random(width/2,width-10);Y = random(20,height-20);Rot=random(0,360);
    }
  }
  boolean insideWall(){
    for(int i=0;i<wallList.size();i++){
      if(rectCol(this.X-this.XSize/2,this.Y-this.YSize/2,this.XSize,this.YSize,wallList.get(i).X-wallList.get(i).XSize,wallList.get(i).Y-wallList.get(i).YSize,wallList.get(i).XSize,wallList.get(i).YSize)){
        return true;
      }
    }
    return false;
  }
  void goBack(){
    this.Y -= this.YVel;
    this.X -= this.XVel;
  }
  void shoot(){
    if(this.ShootWait<1){
      if(this.LR=="left"){
        if(isQ) {
          shoot2();
        }
      }
      if(this.LR=="right"){
        if(isM) {
          shoot2();
        }
      }
    } else {this.ShootWait--;}
  }
  void shoot2(){
    color hej=0;
    if(LR=="left"){hej=color(0,255,0);}
    if(LR=="right"){hej=color(0,0,255);}
    if(this.PowerUp=="none"){
      if(LR=="left"){shotList.add( new Shot(this.X,this.Y,this.Rot,"normal",5,10,0,0,hej));}
      if(LR=="right"){shotList.add( new Shot(this.X,this.Y,this.Rot,"normal",5,10,0,0,hej));}
      this.ShootWait = this.ShootTime;
    } else if(this.PowerUp=="CLUSTERBOMB") {
      shotList.add( new Shot(this.X,this.Y,this.Rot,"CLUSTERBOMB",1,10,color(255,0,0),color(255,0,0),hej));
      this.ShootWait = this.ShootTime;
      this.PowerUp = "none";
    } else if(this.PowerUp=="TRIPLESHOT") {
      shotList.add( new Shot(this.X,this.Y,this.Rot,"normal",2,10,color(200,200,0),color(0,0,0),hej));
      shotList.add( new Shot(this.X,this.Y,this.Rot+10,"normal",2,10,color(200,200,0),color(0,0,0),hej));
      shotList.add( new Shot(this.X,this.Y,this.Rot-10,"normal",2,10,color(200,200,0),color(0,0,0),hej));
      this.ShootWait = this.ShootTime;
      this.PowerUp = "none";
    } else if(this.PowerUp=="SEE"){
      shotList.add( new Shot(this.X,this.Y,this.Rot,"SEE",8,20,color(0,0,255),color(0,0,255),hej));
      this.ShootWait = this.ShootTime;
      this.range=0;
      this.PowerUp = "none";
    } else if(this.PowerUp=="MACHINE"){
      shotList.add( new Shot(this.X,this.Y,this.Rot,"MACHINE",1,15,color(0,0,0),color(255,0,0),hej));
      this.ShootWait = 9;
      powerTimer--;
      if(this.powerTimer<1){this.PowerUp="none";}
    }
  }
  void move(){

    this.XVel *= 0;
    this.YVel *= 0;
    if(this.LR=="left"){
      if(isE){this.YVel+= cos(radians(Rot)) * Speed;this.XVel-= sin(radians(Rot)) * Speed;}
      if(isD){this.YVel-= cos(radians(Rot)) * Speed*0.75;this.XVel+= sin(radians(Rot)) * Speed*0.75;}
      if(isS){this.RotVel-=RotSpeed;}
      if(isF){this.RotVel+=RotSpeed;}

    }
    if(this.LR=="right"){
      if(isUp){this.YVel+= cos(radians(Rot)) * Speed;this.XVel-= sin(radians(Rot)) * Speed;}
      if(isDown){this.YVel-= cos(radians(Rot)) * Speed*0.75;this.XVel+= sin(radians(Rot)) * Speed*0.75;}
      if(isLeft){this.RotVel-=RotSpeed;}
      if(isRight){this.RotVel+=RotSpeed;}

    }
    
    this.X+=this.XVel;
    this.Y+=this.YVel;
 
    this.Rot+=this.RotVel;
    this.RotVel=0;
  }
  
  void drawIt(){
    strokeWeight(2);
    rectMode(CENTER);
    ellipseMode(CENTER);
    fill(255); stroke(0);
    if(Dead){fill(255,0,0);}
    pushMatrix();
    scale(1);
    translate(this.X,this.Y);
    rotate(radians(this.Rot));
    if(LR=="left"){fill(0,255,0);} else if(LR=="right"){fill(0,0,255);}
    if(Dead){fill(255,0,0);}
    if(!Dead){rect(0,0,XSize*1,YSize*1); // main tank box
    } else {rect(0,0,XSize*1,YSize*1,10);}
    fill(0); // ELLIPSE COLOR
    ellipse(0,0,XSize*0.6,YSize*0.8); // draw ellipse
    translate(0,YSize/3); // move gun
    fill(0); //GUN COLOR
    if(this.PowerUp!="none"){fill(255,25,25);}
    rect(0,0,XSize*0.25,YSize*0.75); // draw gun
    
    popMatrix();
  }
}