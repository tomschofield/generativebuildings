class Window {
  String type;
  float w;
  float h;
  float x;
  float y;
  float numTris;
  color col;
  WonkyRect wonkyRect;
  WonkyRect [] panes;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Window(String ty, float _w, float _h, float _x, float _y, color _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    color strokeCol  =color(23, 69, 17);

    wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1, 0.5), col, strokeCol);
    if (type.equals("home")) {
      panes = new WonkyRect[4];
      strokeCol  =color(23, 69, 37);
      float paneW = w*0.35;
      float paneH = h*0.35;
      color paneColour = color(hue(col),saturation(col),brightness(col)-30);
      //top left
      panes[0] = new WonkyRect(w*0.1, h*0.1, paneW, paneH, 3, random(0.1, 0.2),paneColour, strokeCol);
      //top right
      panes[1] = new WonkyRect((w*0.2)+paneW, h*0.1, paneW, paneH, 3, random(0.1, 0.2),paneColour, strokeCol);
      //bottom left
      panes[2] = new WonkyRect(w*0.1, (h*0.2)+paneH, paneW, paneH, 3, random(0.1, 0.2), paneColour,strokeCol);
      //bottom right
      panes[3] = new WonkyRect((w*0.2)+paneW, (h*0.2)+paneH, paneW, paneH, 3, random(0.1, 0.2), paneColour, strokeCol);
    }
  }

  void display() {
    pushStyle();
    pushMatrix();
    fill(col);

    //rect(x,y,w,h);
    translate(x, y);
    wonkyRect.display();
    if (type.equals("home")) {
      for (int i=0; i<panes.length; i++) {
        panes[i].display();
      }
    }
    popStyle();
    popMatrix();
  }
}
