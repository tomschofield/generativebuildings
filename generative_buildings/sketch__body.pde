class Body {
  float x, y, w, h;
  String type;
  color col;
  WonkyRect wonkyRect;
  WonkyRect [] rects;
  Body(String _ty, float _w, float _h, color _col) {
    col = _col;
    w = _w;

    h = _h;
    type = _ty;
    color strokeCol  =color(23, 69, 17);
    

     wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1,1.2), col, strokeCol); 
    
  }
  void display() {
    pushStyle();
    fill(col);
    //rect(0, 0, w, h);
    wonkyRect.display();
    popStyle();
    
  }
}
