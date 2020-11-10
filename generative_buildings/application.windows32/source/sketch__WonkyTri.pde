class WonkyTri {
  float x, y, x1, y1, x2, y2;
  int subDivisions;
  float wonk;
  color col, strokeCol;
  PVector [] vertexPoints; 
  WonkyTri(float _x, float _y, float _x1, float _y1, float _x2, float _y2, int _subDivisions, float _wonk, color _col, color _strokeCol) {
    x = _x;
    y = _y;
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;

    subDivisions = _subDivisions;
    wonk = _wonk;
    col = _col;
    strokeCol = _strokeCol;

    vertexPoints = new PVector[3*subDivisions];
    float subSectionX = (x1-x)/subDivisions;
    float subSectionY = (y1-y)/subDivisions;
   // println("subSectionX",subSectionX,"subSectionY",subSectionY);

    int index = 0;
    //top edgei
    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(+ random(-wonk, wonk)+x+(i*subSectionX), + random(-wonk, wonk)+y + (i*subSectionY) );
      index ++;
    }
    subSectionX = (x2-x1)/subDivisions;
    subSectionY = (y2-y1)/subDivisions;

    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(+ random(-wonk, wonk)+x1+(i*subSectionX),+ random(-wonk, wonk)+ y1 + (i*subSectionY) );
      index ++;
    }

    subSectionX = (x-x2)/subDivisions;
    subSectionY = (y-y2)/subDivisions;

    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(+ random(-wonk, wonk)+x2+(i*subSectionX), + random(-wonk, wonk)+y2 + (i*subSectionY) );
      index ++;
    }
  }


  void display() {
    pushStyle();
    fill(col);
    stroke(strokeCol);
    beginShape();
    for (int i=0; i<vertexPoints.length; i++) {
      vertex(vertexPoints[i].x, vertexPoints[i].y );
   //   ellipse(vertexPoints[i].x, vertexPoints[i].y ,5,5);
    }
    vertex(vertexPoints[0].x, vertexPoints[0].y );
    endShape();
    popStyle();
  }
}
