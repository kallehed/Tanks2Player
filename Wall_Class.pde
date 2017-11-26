class Level {

  ArrayList<Wall> wList = new ArrayList<Wall>();
  Vector t1Pos; Vector t2Pos;
  Level(ArrayList<Wall> wLists){
    wList = wLists;
  }
}

class Wall{
  float X,Y,XSize,YSize;
  color C; boolean working=true,important=false;
  Wall(float Xs, float Ys, float XSizes, float YSizes,color Cs,boolean importants){
    this.X = Xs; this.Y = Ys; this.XSize = XSizes;this.YSize=YSizes;this.C=Cs;this.important=importants;
  }
  void cycle(){
    
    this.drawIt();
  }
  void drawIt(){
    rectMode(CENTER);
    pushMatrix();
    fill(this.C); stroke(C);
    
    translate(this.X,this.Y);
    rect(0,0,this.XSize,this.YSize);
    popMatrix();
  }
}
class Vector{float X; float Y; Vector(float Xs, float Ys){this.X=Xs;this.Y=Ys;}}