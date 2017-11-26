class PowerUp{
  float X,Y,Size,HP=1;
  String type; float vibration,vibrationAcc;
  PowerUp(String types,float Xs,float Ys){
    this.type = types; this.X=Xs;this.Y=Ys;
    this.Size=20;this.vibration=0;this.vibrationAcc=15;
  }
  void cycle(){
    if(HP>0){
      this.vibration+=vibrationAcc+20;
      this.vibrationAcc-=0.5;
      this.vibrationAcc=max(-20,vibrationAcc);
      this.col();
      this.getPickedUp();
      this.drawIt();
    }
  }
  void col(){
    for(int i=0;i<wallList.size();i++){
      Wall w = wallList.get(i);
      if(rectCol(X-Size/2,Y-Size/2,Size,Size,w.X-w.XSize/2,w.Y-w.YSize/2,w.XSize,w.YSize)){
        this.X=random(width);this.Y=random(height);
      }
    }
  }
  void getPickedUp(){
    if(rectCol(X-Size/2,Y-Size/2,Size,Size,tank1.X-tank1.XSize/2,tank1.Y-tank1.YSize/2,tank1.XSize,tank1.YSize)){
      this.pickUped(1);
    }
    if(rectCol(X-Size/2,Y-Size/2,Size,Size,tank2.X-tank2.XSize/2,tank2.Y-tank2.YSize/2,tank2.XSize,tank2.YSize)){
      this.pickUped(2);
    }
  }
  void pickUped(float tank){
    
    if(this.type!="SEE"&&this.type!="MACHINE"){
      if(tank==1){
        tank1.PowerUp=this.type;
      } else if(tank==2){
        tank2.PowerUp=this.type;
      }
    } else if(this.type=="SEE"){
      if(tank==1){
        tank1.range += 200;
        tank1.PowerUp="SEE";
      } else if(tank==2) {
        tank2.range += 200;
        tank2.PowerUp="SEE";
      }
    } else if(this.type=="MACHINE"){

      if(tank==1){
        tank1.powerTimer=5;
        tank1.PowerUp="MACHINE";
      } else if(tank==2) {
        tank2.powerTimer=5;
        tank2.PowerUp="MACHINE";
      }
    }
    HP--;
  }
  void drawIt(){
    rectMode(CENTER); fill(255);stroke(0);
    pushMatrix();
   
    translate(X,Y);
    scale(1+sin(radians(vibration))/3);
    rect(0,0,Size,Size); //INSIDE RECT
    stroke(0,255,0); noFill();
    rect(0,0,Size+4,Size+4); // OUTSIDE GREEN RECT
    this.drawSymbol();
    popMatrix();
  }
  void drawSymbol(){
    fill(255); stroke(0);
    switch (type) {
      case "CLUSTERBOMB":
        this.clusterSymbol();
        break;
      case "TRIPLESHOT":
        this.tripleshotSymbol();
        break;
      case "SEE":
        this.seeSymbol();
        break;
      case "MACHINE":
        this.machineSymbol();
        break;
    }
  }
  void machineSymbol() {
    line(-5,-5,5,-5);
    line(-4,-5,-4,3);
    line(2,-3,2,3);
  }
  void seeSymbol(){
    point(0,-10);point(0,-5);point(0,0);point(0,5);point(0,10);
  }
  void clusterSymbol(){
    rect(0,0,2,2);
    point(0,0);point(-5,0);point(5,0);point(0,5);point(0,-5);
  }
  void tripleshotSymbol(){
    rect(0,4,4,10);
    point(0,-6);point(4,-4);point(-4,-4);
  }
}