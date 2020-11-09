class WonkyRect {
  float x, y, w, h;
  int subDivisions;
  float wonk;
  color col,strokeCol;
  PVector [] vertexPoints; 
  WonkyRect(float _x,float _y,float _w,float _h,int _subDivisions, float _wonk, color _col, color _strokeCol) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    subDivisions = _subDivisions;
    wonk = _wonk;
    col = _col;
    strokeCol = _strokeCol;
    
    vertexPoints = new PVector[4*subDivisions];
    float subSectionX = w/subDivisions;
    float subSectionY = h/subDivisions;
   
    int index = 0;
     //top edgei
    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(x+(i*subSectionX), y + random(-wonk, wonk) );
      index ++;
    }
    //right edge
    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(x+w+random(-wonk, wonk) , y + (i*subSectionY));
      index ++;
    }
    //bottom edge
    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(x+w -(i*subSectionX), y + h+ random(-wonk, wonk));
      index ++;
    }
     //left edge
    for (int i=0; i<subDivisions; i++) {
      vertexPoints[index] =  new PVector(x+random(-wonk, wonk) , y + h - (i*subSectionY));
      index ++;
    }
  }
  
  
  void display() {
    pushStyle();
    fill(col);
    stroke(strokeCol);
    beginShape();
    int index = 0;
    vertex(x, y);
    //start the top line
    for (int i=0; i<subDivisions; i++) {
      vertex(vertexPoints[index].x,vertexPoints[index].y );
      //ellipse(vertexPoints[index].x,vertexPoints[index].y,5,5);
      index ++;
    }
    vertex(x+w, y);
    for (int i=0; i<subDivisions; i++) {
      vertex(vertexPoints[index].x,vertexPoints[index].y );
      index ++;
    }
    vertex(x+w, y+h);
    for (int i=0; i<subDivisions; i++) {
      vertex(vertexPoints[index].x,vertexPoints[index].y );
      index ++;
    }
    vertex(x, y+h);
    for (int i=0; i<subDivisions; i++) {
      vertex(vertexPoints[index].x,vertexPoints[index].y );
      index ++;
    }
    vertex(x, y);
    endShape();
    popStyle();
  }
}
