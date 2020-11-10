class WonkySemi {
  float x, y, r;
  int subDivisions;
  float wonk;
  color col, strokeCol;
  PVector [] vertexPoints;
  WonkySemi(float _x, float _y, float _r, int _subDivisions, float _wonk, color _col, color _strokeCol) {
    x = _x;
    y = _y;
    r= _r;

    subDivisions = _subDivisions;
    wonk = _wonk;
    col = _col;
    strokeCol = _strokeCol;

    vertexPoints = new PVector[subDivisions];
    float h = x+r;
    float k = y;
    
    float t = PI;
    float inc = PI/(vertexPoints.length-1);
    for (int i=0; i<vertexPoints.length; i++) {
      float x = r*cos(t) + h;
      float y = r*sin(t) + k;
      vertexPoints[i] =  new PVector(x,y);
      t+=inc;
    }

    //float subSectionX = w/subDivisions;
    //float subSectionY = h/subDivisions;

    //int index = 0;
    // //top edgei
    //for (int i=0; i<subDivisions; i++) {
    //  vertexPoints[index] =  new PVector(x+(i*subSectionX), y + random(-wonk, wonk) );
    //  index ++;
    //}
    ////right edge
    //for (int i=0; i<subDivisions; i++) {
    //  vertexPoints[index] =  new PVector(x+w+random(-wonk, wonk) , y + (i*subSectionY));
    //  index ++;
    //}
    ////bottom edge
    //for (int i=0; i<subDivisions; i++) {
    //  vertexPoints[index] =  new PVector(x+w -(i*subSectionX), y + h+ random(-wonk, wonk));
    //  index ++;
    //}
    // //left edge
    //for (int i=0; i<subDivisions; i++) {
    //  vertexPoints[index] =  new PVector(x+random(-wonk, wonk) , y + h - (i*subSectionY));
    //  index ++;
    //}
  }


  void display() {
    pushStyle();
    fill(col);
    stroke(strokeCol);
    beginShape();
    vertex(x, y);
   // vertex(vertexPoints[0].x, vertexPoints[0].y);
    for (int i=0; i<subDivisions; i++) {
      vertex(vertexPoints[i].x, vertexPoints[i].y );
    }
    //vertex(vertexPoints[vertexPoints.length-1].x, vertexPoints[vertexPoints.length-1].y );
    vertex(x, y);

    endShape();
    popStyle();
  }
}
