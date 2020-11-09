class BLine {
  Building [] buildings;
  float baseLine;
  float w=0;
  float saturation;
  float bWidthBase;
  BLine(float _baseline, int numBuildings, float _sat, float _bWidthBase) {

    saturation = _sat;
    baseLine = _baseline;
    buildings = new Building [numBuildings];
    bWidthBase = _bWidthBase;
    float xPos = 0;
    for (int i=0; i<buildings.length; i++) {
      float bWidth = random(bWidthBase, bWidthBase*1.3);

      color col =color(random(360), random(saturation-10, saturation+10), random(75, 85));

      float typeChooser = random(100);
      //colorMode(HSB);
      //color col =color(random(10, 20), random(25, 30), random(75, 85));
      float doorHeight = random(14, 20);

      if (typeChooser < 20) {
        buildings [i] = new Building(xPos, baseLine, bWidth, bWidth*random(0.4, 0.6), doorHeight, "home", col);
      } else if (typeChooser >= 20  && typeChooser <40) {
        //bWidth*=random(2,4);
        buildings [i] = new Building(xPos, baseLine, bWidth, bWidth*random(0.4, 0.6), doorHeight, "shop", col);
      }
      else if (typeChooser >= 40  && typeChooser <60) {
       
        buildings [i] = new Building(xPos, baseLine, bWidth, bWidth*random(0.4, 0.6), doorHeight, "townHall", col);
      }
      else if (typeChooser >= 60  && typeChooser <80) {
        bWidth*=random(2, 4);
        buildings [i] = new Building(xPos, baseLine, bWidth, bWidth*random(0.2, 0.3), doorHeight, "factory", col);
      }
      else if (typeChooser >= 80  && typeChooser <90) {
        //bWidth*=random(2, 4);
        buildings [i] = new Building(xPos, baseLine, bWidth, bWidth*random(1.2, 3.3), doorHeight, "towerblock", col);
      }
      else if (typeChooser >= 90  && typeChooser <100) {
        //bWidth*=random(2, 4);
        buildings [i] = new Building(xPos, baseLine, bWidth, bWidth*random(0.4, 0.6), doorHeight, "mosque", col);
      }


      xPos+=bWidth;
      xPos+=random(10);
      w = xPos;
    }
  }
  boolean allBuildingsAreSquashed(){
    boolean areSquashed = true;
    for (int i=0; i<buildings.length; i++) {
      if(buildings [i].scaleY>0){
        areSquashed = false;
      }
    }
    return areSquashed;
  }
  void setToSquashed() {
    for (int i=0; i<buildings.length; i++) {
      buildings [i].scaleY=0;
    }
  }
  void squash() {
    for (int i=0; i<buildings.length; i++) {
      if (buildings [i].scaleY>=0)      buildings [i].scaleY-=buildings [i].scaleSpeed;
      if(buildings [i].scaleY<0)buildings [i].scaleY=0;
    }
    
  }
  void unSquash() {
    for (int i=0; i<buildings.length; i++) {
      if (buildings [i].scaleY<=1)      buildings [i].scaleY+=buildings [i].scaleSpeed;
    }
  }
  void display() {
    for (int i=0; i<buildings.length; i++) {
      buildings [i].display();
    }
  }
}
