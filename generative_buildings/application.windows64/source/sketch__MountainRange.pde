class MountainRange {
  int x, y, w, h, numPoints;
  color col;
  PVector [] points;
  MountainRange(int _x, int _y, int _w, int _h, int _numPoints, color _col) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    col =_col;
    numPoints = _numPoints;
    points = new PVector [numPoints];
    float xSpace = w/numPoints;
    float runningHeight = random(0.5*h, h);
    for (int i=0; i<points.length; i++) {
      runningHeight+=random(-(h*0.1),(h*0.1));
      if(runningHeight<0)runningHeight += (2*abs(runningHeight));
      float px= x+ (xSpace*i);
      float py = y-runningHeight;
      points[i]=new PVector(px, py);
    }
  }
  void display() {
    fill(col);
    beginShape();
    vertex(x, y);
    for (int i=0; i<points.length; i++) {
      vertex(points[i].x, points[i].y);
    }

    vertex(x+w, y);
    vertex(x, y);
    endShape();
  }
}
