class RoofDecoration {
  String type;
  float w;
  float h;
  float x;
  float y;

  color col;
  //WonkyRect wonkyRect;
  WonkyRect [] rects;
  WonkyTri tri;

  RoofDecoration(String ty, float _x, float _y, float _w, float _h, color _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;

    color strokeCol  =color(23, 69, 17);


    // wonkyRect  = new WonkyRect(0, 0, w, h, 15, random(0.1, 0.5), col, strokeCol);

    if (type.equals("waterTower")) {
      rects =  new WonkyRect[3];
      //mainBody
      //rects[0]= new WonkyRect(0, -h, w, h, 5, random(0.1, 0.2), col, strokeCol);

      rects[0]= new WonkyRect(0, -h, w, h*0.7, 5, random(0.1, 0.2), col, strokeCol);
      //left leg
      rects[1]= new WonkyRect(w*0.2, -h*0.3, w*0.2, h*0.3, 5, random(0.1, 0.2), col, strokeCol);
      //right leg
      rects[2]= new WonkyRect(w-(w*0.4), -h*0.3, w*0.2, h*0.3, 5, random(0.1, 0.2), col, strokeCol);

      float triW = w*1.3;
      float triX1 = 0-(w*0.15);
      float triX2 = w/2;
      float triX3 = w+(w*0.15);
      tri = new WonkyTri(triX1, -h, triX2, -h*1.3, triX3, -h, 4, 0.1, col, strokeCol );
      //WonkyTri(float _x, float _y, float _x1, float _y1, float _x2, float _y2, int _subDivisions, float _wonk, color _col, color _strokeCol)
    } else if (type.equals("aerial")) {
      w*=0.7;
      //float triX1 = 0;
      //float triX2 = w/2;
      //float triX3 = w;
      //tri = new WonkyTri(triX1, 0, triX2, -h, triX3, 0, 4, 0.1, col, strokeCol );

      rects =  new WonkyRect[4];

      rects[0]= new WonkyRect(0, -h*0.8, w, h*0.1, 5, random(0.1, 0.2), col, strokeCol);
      rects[1]= new WonkyRect(0, -h*1.1, w*0.2, h*0.5, 5, random(0.1, 0.2), col, strokeCol);
      rects[2]= new WonkyRect(w, -h*1.1, w*0.2, h*0.5, 5, random(0.1, 0.2), col, strokeCol);
      float mastWidth = w*0.2;
      rects[3]= new WonkyRect((w/2)-(mastWidth*0.5), -h, mastWidth, h, 5, random(0.1, 0.2), col, strokeCol);
    }
    else if (type.equals("cellMast")) {
      w*=0.7;
      float triX1 = 0;
      float triX2 = w/2;
      float triX3 = w;
      tri = new WonkyTri(triX1, 0, triX2, -h, triX3, 0, 4, 0.1, col, strokeCol );

      rects =  new WonkyRect[3];

      rects[0]= new WonkyRect(0, -h*0.8, w, h*0.1, 5, random(0.1, 0.2), col, strokeCol);
      rects[1]= new WonkyRect(0, -h*1.1, w*0.2, h*0.5, 5, random(0.1, 0.2), col, strokeCol);
      rects[2]= new WonkyRect(w, -h*1.1, w*0.2, h*0.5, 5, random(0.1, 0.2), col, strokeCol);
    }
  }

  void display() {
    pushStyle();
    pushMatrix();
    fill(col);

    translate(x, y);

    // wonkyRect.display();
    for (int i=0; i<rects.length; i++) {
      rects[i].display();
    }
    
    if(type.equals("aerial")==false) tri.display();
    popStyle();
    popMatrix();
  }
}
