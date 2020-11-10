class Minaret {
  String type;
  float w;
  float h;
  float x;
  float y;
  float numTris;
  color col;
  WonkyRect tower;
  WonkySemi dome;
  Window window;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Minaret(String ty, float _w, float _h, float _x, float _y, color _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    color strokeCol  =color(23, 69, 17);
  
    tower  = new WonkyRect(0, 0, w, h, 5, random(0.1, 0.5), col, strokeCol);
    //String ty, float _w, float _h, float _x, float _y, color _col
    color windowColour =  color(0, random(0, 10), random(200, 255));
    window  = new Window("minaret", w*0.5, h*0.2, x+(w*0.25),h*0.2, windowColour);
    //float _x, float _y, float _r, int _subDivisions, float _wonk, color _col, color _strokeCol
    dome = new WonkySemi(x,0,w*0.5,8,random(0.1, 0.5),col,strokeCol);
  }

  void display() {
    pushStyle();
    pushMatrix();
    fill(col);

    //rect(x,y,w,h);    
    translate(x, y);
    tower.display();
    dome.display();
    window.display();
    popStyle();
    popMatrix();
  }
}
