class BLine {
  Building [] buildings;
  float baseLine;
  float w=0;
  float saturation;
  float lineWidth;
  float lineHeight;
  PImage strip;
  
  float bWidthBase;
  BLine(float _baseline, int numBuildings, float _sat,float brightness, float _bWidthBase) {
    strip = loadImage("paper_texture_gradient_strip1.png");
    saturation = _sat;
    baseLine = _baseline;
    buildings = new Building [numBuildings];
    bWidthBase = _bWidthBase;
    float xPos = 0;
    float buildingSpaceMin =10;
    float buildingSpaceMax = 50;
    for (int i=0; i<buildings.length; i++) {
      float bWidth = random(bWidthBase, bWidthBase*1.3);

      color col =color(random(360), random(saturation-10, saturation+10),brightness);

      float typeChooser = random(100);
      //colorMode(HSB);
      //color col =color(random(10, 20), random(25, 30), random(75, 85));
      float doorHeight = random(14, 20);
      float buildingHeight=0;
      if (typeChooser < 20) {
        buildingHeight= bWidth*random(0.4, 0.6);
        buildings [i] = new Building(xPos, baseLine, bWidth,buildingHeight, doorHeight, "home", col);
      } else if (typeChooser >= 20  && typeChooser <40) {
        //bWidth*=random(2,4);
        buildingHeight= bWidth*random(0.4, 0.6);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight, "shop", col);
      }
      else if (typeChooser >= 40  && typeChooser <60) {
       buildingHeight= bWidth*random(0.4, 0.6);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight*2, "townHall", col);
      }
      else if (typeChooser >= 60  && typeChooser <80) {
        
        bWidth*=random(2, 4);
        buildingHeight= bWidth*random(0.2, 0.3);
        buildings [i] = new Building(xPos, baseLine, bWidth,buildingHeight , doorHeight, "factory", col);
      }
      else if (typeChooser >= 80  && typeChooser <90) {
        buildingHeight= bWidth*random(1.2, 3.3);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight, "towerblock", col);
      }
      else if (typeChooser >= 90  && typeChooser <100) {
        buildingHeight= bWidth*random(0.4, 0.6);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight*1.5, "mosque", col);
      }

      if(buildingHeight>lineHeight) lineHeight = buildingHeight;
      xPos+=bWidth;
      xPos+=random(buildingSpaceMin,buildingSpaceMax);
      lineWidth =xPos;
      w = xPos;
    }
  }
  boolean allBuildingsAreSquashed(){
    boolean areSquashed = true;
    for (int i=0; i<buildings.length; i++) {
      if(buildings [i].scaleY>0.01){
        areSquashed = false;
      }
    }
    return areSquashed;
  }
   boolean allBuildingsAreUnSquashed(){
    boolean areUnSquashed = true;
    for (int i=0; i<buildings.length; i++) {
      if(buildings [i].scaleY<1){
        areUnSquashed = false;
      }
    }
    return areUnSquashed;
  }
  void setToSquashed() {
    for (int i=0; i<buildings.length; i++) {
      buildings [i].scaleY=0.01;
    }
  }
  void squash() {
    for (int i=0; i<buildings.length; i++) {
      if (buildings [i].scaleY>=0.01)      buildings [i].scaleY-=buildings [i].scaleSpeed;
      if(buildings [i].scaleY<0)buildings [i].scaleY=0.01;
    }
    
  }
  void unSquash() {
    for (int i=0; i<buildings.length; i++) {
      if (buildings [i].scaleY<=1)      buildings [i].scaleY+=buildings [i].scaleSpeed;
    }
  }
  void display() {
    for (int i=0; i<buildings.length; i++) {
      //try{
      buildings [i].display();
     // }
      //catch(Error e){
       //println(e); 
      //}
    }
    pushStyle();
    fill(200,60,30);
   // image(strip,0,baseLine,lineWidth,lineHeight);
   // rect(0,baseLine,lineWidth,lineHeight);
    
    popStyle();
  }
}
