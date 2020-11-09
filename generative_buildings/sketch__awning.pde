class Awning {
  String type;
  float w;
  float h;
  float x;
  float y;
 
  color col;
  WonkyRect wonkyRect;
  WonkyRect [] rects;
  int numStripes;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Awning(String ty, float _x, float _y, float _w, float _h, int _numStripes, color _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    numStripes = _numStripes;
    color strokeCol  =color(23, 69, 17);
    
    rects = new WonkyRect [numStripes];
    wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1, 0.5), col, strokeCol);
    float stripeWidth = w/numStripes;
    for(int i=0;i<rects.length;i++){
       color awningCol =  color(random(360), 30, random(75, 85));
      rects[i] = new WonkyRect(i*stripeWidth, 0, stripeWidth, h, 5, random(0.1, 0.2), awningCol, strokeCol);
    }
  }

  void display() {
    pushStyle();
    pushMatrix();
   // stroke(255,255,255);
    fill(col);

    //
    
      
    translate(x, y);
   // rect(x,y,w,h);  
    wonkyRect.display();
    for(int i=0;i<rects.length;i++){
      rects[i].display();
      //rect(rects[i].x,rects[i].y,rects[i].w,rects[i].h);
    }
    popStyle();
    popMatrix();
  }
}
