class Roof {
  String type;
  float w;
  float h;
  int numTris;
  color col;
  WonkyTri tri;
  WonkyTri [] tris;
  WonkyRect wonkyRect;
  WonkySemi semi;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Roof(String ty, float _w, float _h, color _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    numTris = int(random(5, 9));
    color strokeCol  =color(23, 69, 17);
    if (type.equals("triangle")) {
      tri = new WonkyTri(0, 0, w/2, -h, w, 0, 5, 0.3, col, strokeCol );
      float hi = h*random(0.7, 1.2);

      float wi = w*random(0.1, 0.3);
      wonkyRect  = new WonkyRect(random( 0, w-wi), -hi, wi, hi, 5, random(0.1, 0.3), col, strokeCol);
    } else if (type.equals("townHall")) {

      float hi = h*random(0.3, 0.4);
      tri = new WonkyTri(0, -hi, w/2, -h, w, 0, 15, 0.3, col, strokeCol );

      wonkyRect  = new WonkyRect(0, -hi, w, hi, 5, random(0.1, 0.3), col, strokeCol);
    } else if (type.equals("saw")) {
      float hi = h*random(1.9, 3.9);

      float wi = w*random(0.02, 0.08);
      wonkyRect  = new WonkyRect(random( 0, w-wi), -hi, wi, hi, 5, random(0.1, 0.3), col, strokeCol);

      float roofSectionWidth = w/numTris;

      tris = new WonkyTri[numTris];
      boolean leanLeft = true;
      if (random(1)>=0.5) leanLeft = false;
      for (int i=0; i<numTris; i++) {
        if (leanLeft) {
          tris[i]  = new WonkyTri( i*roofSectionWidth, 0, (i*roofSectionWidth)+roofSectionWidth, -h, (i*roofSectionWidth)+roofSectionWidth, 0, 15, 0.3, col, strokeCol);
        } else {
          tris[i]  = new WonkyTri( i*roofSectionWidth, 0, (i*roofSectionWidth), -h, (i*roofSectionWidth)+roofSectionWidth, 0, 15, 0.3, col, strokeCol);
        }
      }
    } else if (type.equals("shop")) {
      wonkyRect  = new WonkyRect(0, -h, w, h, 5, random(0.1, 0.3), col, strokeCol);
      
    }
     else if (type.equals("mosque")) {
       semi = new WonkySemi(0,0,w*0.5,15 ,random(0.1, 0.3), col, strokeCol);
     }
  }

  void display() {
    pushStyle();
    fill(col);

    strokeWeight(1);
    if (type.equals("triangle")) {
      // triangle(0, 0, w/2, -h, w, 0);
      
      wonkyRect.display();
      tri.display();
    } else if (type.equals("townHall")) {
      tri.display();
      wonkyRect.display();
    } else if (type.equals("saw")) {
      wonkyRect.display();

      pushMatrix();
      for (int i=0; i<numTris; i++ ) {
        // triangle(0, 0, roofSectionWidth, -h, roofSectionWidth, 0);
        // translate(roofSectionWidth, 0);
        tris[i].display();
        //triangle(i, 0, i +(roofSectionWidth/2), -h, i+roofSectionWidth , 0);
      }
      popMatrix();
    } else if (type.equals("shop")) {
      wonkyRect.display();
    }
     else if (type.equals("mosque")) {
      semi.display();
    }
    popStyle();
  }
}
