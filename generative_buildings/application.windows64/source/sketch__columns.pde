class Columns {
  float x, y, w, h;
  String type;
  color col;
  WonkyRect wonkyRect;
  WonkyRect [] rects;
  color columnColour ;
  Columns(String _ty, float _w, float _h, color _col) {
    col = _col;
    w = _w;
  
    h = _h;
    type = _ty;
    color strokeCol  =color(23, 69, 17);
    float saturation =100;
     columnColour = color(random(360),saturation(col),brightness(col));
     //col =color(random(360), random(saturation-10, saturation+10), random(75, 85));
    if (type.equals("townHall")) {
      wonkyRect  = new WonkyRect(w*0.1, 0, w*0.8, h, 5, random(0.1, 1.5), col, strokeCol);
      rects = new WonkyRect[int(random(4, 7))+2];
      float stepHeight = h*0.1;
      //bottom step
      rects[0] = new  WonkyRect(0, h-stepHeight, w, stepHeight, 5, random(0.1, 0.3), col, strokeCol);
      //top step
      rects[1] = new  WonkyRect(w*0.05, h-(2*stepHeight), w*0.9, stepHeight, 5, random(0.1, 0.3), col, strokeCol);

      //now the columns
      float columnWidth = w *0.1;
      float columnSpace = w/(rects.length-1.5);
      for (int i=2; i<rects.length; i++) {
        rects[i] = new WonkyRect((i-1.5)*columnSpace, 0, columnWidth, h-(2*stepHeight), 5, random(0.1, 0.3), columnColour, strokeCol);
      }
    } else {
      wonkyRect  = new WonkyRect(0, 0, w*0.9, h, 5, random(0.1, 1.5), col, strokeCol);
    }
  }
  void display() {
    pushStyle();
    fill(col);
    //rect(0, 0, w, h);
   // wonkyRect.display();
    if (type.equals("townHall")) {
      for (int i=0; i<rects.length; i++) {
        rects[i].display();
      }
    }
    popStyle();
  }
}
