class Door {
  String type;
  float w;
  float h;
  float x;
  float y;
  float numTris;
  color col;
  WonkyRect wonkyRect;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Door(String ty, float _w, float _h, float _x, float _y, color _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    color strokeCol  =color(23, 69, 17);
  
    wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1, 0.5), col, strokeCol);
  }

  void display() {
    pushStyle();
    pushMatrix();
    fill(col);

    //rect(x,y,w,h);    
    translate(x, y);
    wonkyRect.display();
    popStyle();
    popMatrix();
  }
}
