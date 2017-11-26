class Shot {
  float X,Y,Size=10,XVel=0,YVel=0,Rot=0,Speed=10,HP=5,Dist;
  int hurtTimer=5;
  String shotType="normal"; color C,S,ofColor;
  Shot(float Xs, float Ys,float Rots,String shotTypes,float HPs,float Speeds,color Cs,color Ss,color ofColors) {
    this.X = Xs; this.Y = Ys; this.Rot = Rots;this.shotType=shotTypes;this.HP=HPs;this.Speed=Speeds;this.C=Cs;this.S=Ss;this.ofColor=ofColors;
  }
  void cycle(){
    if( (HP>0)     || (shotType=="SEE"&&Dist<150) || (shotType=="nodraw") ){
      this.move();
      if(shotType!="SEE"){this.bounce();}
      if(this.shotType!="nodraw"){this.drawIt();}
      if(shotType!="CLUSTERBOMB"){hurtTimer--;} else {hurtTimer-=0.25;} 
      if(shotType=="SEE"){hurtTimer=0;}
    }
  }
  void bounce(){ // BOUNCe!
    for(int i = 0; i<wallList.size();i++){
      Wall w = wallList.get(i);
      if(rectCol(X-Size/2,Y-Size/2,Size,Size,w.X-w.XSize/2,w.Y-w.YSize/2,w.XSize,w.YSize)){
        if(this.ofColor==255){wallList.get(i).working=false;}
        if(shotType!="nodraw"&&this.ofColor!=255){wallList.get(i).C=ofColor+int(random(-100,100));}
        if(shotType !="CLUSTERBOMB"){
          this.HP--;
          if(this.Y-this.Size/2>w.Y-w.YSize/2&&this.Y+this.Size/2<w.Y+w.YSize/2){ // IF IT IS ON THE RIGHT SIDE
            if(this.X>w.X){this.X=w.X+w.XSize/2+this.Size/2; this.Rot=360-Rot;}
            if(this.X<w.X){this.X=w.X-w.XSize/2-this.Size/2; this.Rot=360-Rot;}
          } else {
            if(this.Y>w.Y){this.Y=w.Y+w.YSize/2+this.Size/2;this.Rot=180-Rot;}
            if(this.Y<w.Y){this.Y=w.Y-w.YSize/2-this.Size/2;this.Rot=180-Rot;}
          }
        } else if(shotType == "CLUSTERBOMB"){
          for(int in=0;in<360;in+=5){
            shotList.add(new Shot (this.X,this.Y,in,"normal",1,5,0,color(255,0,0),255));
          }
          HP--;
        }
      }
    }
  }
  void move(){
    this.XVel=0;
    this.YVel=0;

    if(shotType!="SEE"){
      this.YVel+= cos(radians(this.Rot)) * Speed;
      this.XVel-= sin(radians(this.Rot)) * Speed;
      this.X += this.XVel;
      this.Y += this.YVel;
    } else {
      for(int i=0;i<5;i++){
        this.XVel=0;
        this.YVel=0;
        this.YVel+= cos(radians(this.Rot)) * 10;
        this.XVel-= sin(radians(this.Rot)) * 10;
        this.X += this.XVel;
        this.Y += this.YVel;
        this.Dist += (abs(this.XVel)+abs(this.YVel));
        this.bounce();
        
      }
    }
  }
  void drawIt(){
    if(shotType=="CLUSTERBOMB"){this.Size=20;} else {this.Size=10;}
    fill(0); stroke(0);rectMode(CENTER);
    pushMatrix();
    translate(this.X,this.Y);
    fill(this.C);stroke(this.S);
    rect(0,0,this.Size,this.Size);
    popMatrix();
  }
}