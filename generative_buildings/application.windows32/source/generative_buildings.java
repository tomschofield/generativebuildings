import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class generative_buildings extends PApplet {


/*
Todo
 mosques
 serial hook up
 make saturation globally controlable
 add gui? parameters: mountain spikeyness , saturation, building widht, number of buildings, zoom
 */
Serial myPort;  // Create object from Serial class
Building b;
BLine line;
BLine line2;
BLine [] lines;
float baseLine;
float globalSaturation=30;
float globalBrightness=85;
float zoomSpeed = 0.003f;
WonkyTri tri;
PImage img;
float joyStickVal = 3.0f;
MountainRange mountains;
MountainRange mountainsDistance;
boolean squash = false;
boolean unSquash = false;
boolean runSerial = true;
public void setup() {
  //size(1200, 800, JAVA2D);
  
  noCursor();
  if (runSerial) {
    String portName = Serial.list()[1];
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil(10);
  }
  baseLine = height*0.4f;
  colorMode(HSB, 360, 100, 100);

  lines = new BLine [10];
  createLines();

  //line = new BLine(baseLine, 40, 10,60);
  //line2 = new BLine(baseLine, 40, 40,60);
  
  int strokeCol  =color(23, 69, 17);

  img = loadImage("paper_texture_mid.png");
  float mountainSaturation = 25;
  int mountainCol  =color(random(300, 330), random(mountainSaturation-10, mountainSaturation+10), random(75, 85));

  mountains = new MountainRange(0, PApplet.parseInt(baseLine), width, PApplet.parseInt(height*0.2f), 300, mountainCol);
  mountainCol  =color(random(300, 330), random(mountainSaturation-20, mountainSaturation), random(75, 85));
  mountainsDistance = new MountainRange(0, PApplet.parseInt(baseLine), width, PApplet.parseInt(height*0.25f), 300, mountainCol);
}
public void scaleFromCentre(float sc, float baseLine) {
  translate(width/2, baseLine);
  scale(sc );
  // translate(0,0,map(mouseY,0,height,0,600));
  translate(-width/2, -baseLine);
  translate(-width*2, 0);
}
public void draw() {
  background(255);
  //float scaleFactor  = map(mouseY, 0, height, 0, 6);
  //joyStickVal = constrain(joyStickVal,170,1023);
  float scaleFactor  = joyStickVal ;//map(joyStickVal, 170, 1023, 0, 6);


  mountainsDistance.display();
  mountains.display();


  for (int i=0; i<lines.length; i++) {
    pushMatrix();
    float sc = scaleFactor*i*i*0.05f;
    // println("sc", sc, frameRate);
    scaleFromCentre(sc, baseLine);

    translate(0, scaleFactor*i*i);//scaleFactor*map(i,0,lines.length,1,4));
    if (sc<5) lines[i].display();
    popMatrix();
  }

  //pushMatrix();
  //scaleFromCentre(scaleFactor*1.3);
  //translate(0, scaleFactor);
  //line2.display();
  //popMatrix();

  image(img, 0, 0, width, height);
  if (squash ==true) {
    println("squash", squash);
    if (!allBuildingsAreSquashed()) {
      squashAll();
    } else {
      regenerateBuildings();
      unSquash=true;
      squash=false;
    }
  }
  if (unSquash ==true) {
    println("unsquash", unSquash);
    if (!allBuildingsAreUnSquashed()) {
      unSquashAll();
    } else {
      unSquash=false;
    }
  }
}
public void keyPressed() {

  if (key=='a' && !unSquash) {
    println("a");
    squash = true;
  } else if (key=='b' && !squash) {
    unSquash = true;
  } else if (key=='c') {
    regenerateBuildings();
  }
}
public void regenerateBuildings() {
  lines = new BLine [10];
  createLines();
  for (int i=0; i<lines.length; i++) {
    lines[i].setToSquashed();
  }
}
public void createLines() {

  for (int i=0; i<lines.length; i++) {
    lines[i]= new BLine(baseLine, 40, map(i, 0, lines.length, 10, globalSaturation), globalBrightness, 60);
  }
}
public void squashAll() {

  for (int i=0; i<lines.length; i++) {
    lines[i].squash();
  }
}
public void unSquashAll() {

  for (int i=0; i<lines.length; i++) {
    lines[i].unSquash();
  }
}
public boolean allBuildingsAreSquashed() {
  boolean areSquashed = true;
  for (int i=0; i<lines.length; i++) {
    if (!lines[i].allBuildingsAreSquashed()) areSquashed=false;
  }
  return areSquashed;
}
public boolean allBuildingsAreUnSquashed() {
  boolean areUnSquashed = true;
  for (int i=0; i<lines.length; i++) {
    if (!lines[i].allBuildingsAreUnSquashed()) areUnSquashed=false;
  }
  return areUnSquashed;
}

public void serialEvent(Serial thisPort) {
  //int inByte = thisPort.read();
  String inString = thisPort.readString();
  //println(inString);
  if (splitTokens(inString, ":").length==2) {

    if (splitTokens(inString, ":")[0].equals("J")) {
      println("got serial", PApplet.parseInt(splitTokens(inString, ":")[1].trim()));
      int val = PApplet.parseInt(splitTokens(inString, ":")[1].trim());
      int centrePoint = 520;
      if (val<centrePoint -20) {
        if (joyStickVal>zoomSpeed) {
          if(val<255){
            joyStickVal-=(2*zoomSpeed);
          }else{
            joyStickVal-=zoomSpeed;
          }
          
        }
      }
      if (val>centrePoint+20) {
        if (joyStickVal<6) {
          if(val<900){
            joyStickVal+=zoomSpeed;
          }else{
            joyStickVal+=(zoomSpeed*2);
          }
          
        }
      }
    } else if (splitTokens(inString, ":")[0].equals("B")) {
      int button = PApplet.parseInt(splitTokens(inString, ":")[1].trim());
      //  println("got serial",button);
      if (button==1&&!squash && !unSquash) {
        squash=true;
      }
      //  squash=true;
    }
  }
}
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
      float bWidth = random(bWidthBase, bWidthBase*1.3f);

      int col =color(random(360), random(saturation-10, saturation+10),brightness);

      float typeChooser = random(100);
      //colorMode(HSB);
      //color col =color(random(10, 20), random(25, 30), random(75, 85));
      float doorHeight = random(14, 20);
      float buildingHeight=0;
      if (typeChooser < 20) {
        buildingHeight= bWidth*random(0.4f, 0.6f);
        buildings [i] = new Building(xPos, baseLine, bWidth,buildingHeight, doorHeight, "home", col);
      } else if (typeChooser >= 20  && typeChooser <40) {
        //bWidth*=random(2,4);
        buildingHeight= bWidth*random(0.4f, 0.6f);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight, "shop", col);
      }
      else if (typeChooser >= 40  && typeChooser <60) {
       buildingHeight= bWidth*random(0.4f, 0.6f);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight*2, "townHall", col);
      }
      else if (typeChooser >= 60  && typeChooser <80) {
        
        bWidth*=random(2, 4);
        buildingHeight= bWidth*random(0.2f, 0.3f);
        buildings [i] = new Building(xPos, baseLine, bWidth,buildingHeight , doorHeight, "factory", col);
      }
      else if (typeChooser >= 80  && typeChooser <90) {
        buildingHeight= bWidth*random(1.2f, 3.3f);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight, "towerblock", col);
      }
      else if (typeChooser >= 90  && typeChooser <100) {
        buildingHeight= bWidth*random(0.4f, 0.6f);
        buildings [i] = new Building(xPos, baseLine, bWidth, buildingHeight, doorHeight*1.5f, "mosque", col);
      }

      if(buildingHeight>lineHeight) lineHeight = buildingHeight;
      xPos+=bWidth;
      xPos+=random(buildingSpaceMin,buildingSpaceMax);
      lineWidth =xPos;
      w = xPos;
    }
  }
  public boolean allBuildingsAreSquashed(){
    boolean areSquashed = true;
    for (int i=0; i<buildings.length; i++) {
      if(buildings [i].scaleY>0.01f){
        areSquashed = false;
      }
    }
    return areSquashed;
  }
   public boolean allBuildingsAreUnSquashed(){
    boolean areUnSquashed = true;
    for (int i=0; i<buildings.length; i++) {
      if(buildings [i].scaleY<1){
        areUnSquashed = false;
      }
    }
    return areUnSquashed;
  }
  public void setToSquashed() {
    for (int i=0; i<buildings.length; i++) {
      buildings [i].scaleY=0.01f;
    }
  }
  public void squash() {
    for (int i=0; i<buildings.length; i++) {
      if (buildings [i].scaleY>=0.01f)      buildings [i].scaleY-=buildings [i].scaleSpeed;
      if(buildings [i].scaleY<0)buildings [i].scaleY=0.01f;
    }
    
  }
  public void unSquash() {
    for (int i=0; i<buildings.length; i++) {
      if (buildings [i].scaleY<=1)      buildings [i].scaleY+=buildings [i].scaleSpeed;
    }
  }
  public void display() {
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
class MountainRange {
  int x, y, w, h, numPoints;
  int col;
  PVector [] points;
  MountainRange(int _x, int _y, int _w, int _h, int _numPoints, int _col) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    col =_col;
    numPoints = _numPoints;
    points = new PVector [numPoints];
    float xSpace = w/numPoints;
    float runningHeight = random(0.5f*h, h);
    for (int i=0; i<points.length; i++) {
      runningHeight+=random(-(h*0.1f),(h*0.1f));
      if(runningHeight<0)runningHeight += (2*abs(runningHeight));
      float px= x+ (xSpace*i);
      float py = y-runningHeight;
      points[i]=new PVector(px, py);
    }
  }
  public void display() {
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
class WonkyRect {
  float x, y, w, h;
  int subDivisions;
  float wonk;
  int col,strokeCol;
  PVector [] vertexPoints; 
  WonkyRect(float _x,float _y,float _w,float _h,int _subDivisions, float _wonk, int _col, int _strokeCol) {
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
  
  
  public void display() {
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
class WonkySemi {
  float x, y, r;
  int subDivisions;
  float wonk;
  int col, strokeCol;
  PVector [] vertexPoints;
  WonkySemi(float _x, float _y, float _r, int _subDivisions, float _wonk, int _col, int _strokeCol) {
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


  public void display() {
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
class WonkyTri {
  float x, y, x1, y1, x2, y2;
  int subDivisions;
  float wonk;
  int col, strokeCol;
  PVector [] vertexPoints; 
  WonkyTri(float _x, float _y, float _x1, float _y1, float _x2, float _y2, int _subDivisions, float _wonk, int _col, int _strokeCol) {
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


  public void display() {
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
class Awning {
  String type;
  float w;
  float h;
  float x;
  float y;
 
  int col;
  WonkyRect wonkyRect;
  WonkyRect [] rects;
  int numStripes;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Awning(String ty, float _x, float _y, float _w, float _h, int _numStripes, int _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    numStripes = _numStripes;
    int strokeCol  =color(23, 69, 17);
    
    rects = new WonkyRect [numStripes];
    wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1f, 0.5f), col, strokeCol);
    float stripeWidth = w/numStripes;
    for(int i=0;i<rects.length;i++){
       int awningCol =  color(random(360), 30, random(75, 85));
      rects[i] = new WonkyRect(i*stripeWidth, 0, stripeWidth, h, 5, random(0.1f, 0.2f), awningCol, strokeCol);
    }
  }

  public void display() {
    pushStyle();
    pushMatrix();
   // stroke(255,255,255);
    fill(col);

    //
    
      
    translate(x, y);
   // rect(x,y,w,h);  
    wonkyRect.display();
    for(int i=0;i<rects.length;i++){
      rects[i].display();
      //rect(rects[i].x,rects[i].y,rects[i].w,rects[i].h);
    }
    popStyle();
    popMatrix();
  }
}
class Body {
  float x, y, w, h;
  String type;
  int col;
  WonkyRect wonkyRect;
  WonkyRect [] rects;
  Body(String _ty, float _w, float _h, int _col) {
    col = _col;
    w = _w;

    h = _h;
    type = _ty;
    int strokeCol  =color(23, 69, 17);
    

     wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1f,1.2f), col, strokeCol); 
    
  }
  public void display() {
    pushStyle();
    fill(col);
    //rect(0, 0, w, h);
    wonkyRect.display();
    popStyle();
    
  }
}
class Building {
  Roof roof;
  Body body;
  Door door;
  Awning awning;
  RoofDecoration decoration;
  Columns columns;
  PFont font;
  Window [] windows;
  Minaret tower1;
  Minaret tower2;
  float x, y, w, h;
  float scaleY = 1.0f;
  float dh;
  float scaleSpeed;
  String type;
  int col;
  //basic typologies are sky scraper, shop, home, mosque,

  Building(float _x, float _y, float _w, float _h, float _dh, String _ty, int _col) {
    col = _col;
    w = _w;
    h = _h;
    dh = _dh;
    type = _ty;
    scaleSpeed = random(0.05f, 0.1f);
    font = loadFont("Dialog-18.vlw");
    textFont(font, 18);
    int roofCol  =color(random(80, 90), random(5, 17), random(60, 75));
    int doorCol  =color(random(10, 30), random(5, 17), random(60, 75));
    float doorW=0;


    if (type.equals("home")) {
      roof = new Roof("triangle", w, w*random(0.2f, 0.4f), roofCol);
      body = new Body("home", w, h, col);

      doorW= dh * random(0.3f, 0.4f);
      float doorXPos = random((doorW*0.5f), w-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeHouseWindows();
      makeWindows("home", 0.2f, 0.4f, 0.3f, 0.4f, 0.2f, 0.4f, 0);
    } else if (type.equals("mosque")) {
      roof = new Roof("mosque", w, w*random(0.3f, 0.6f), roofCol);
      body = new Body("townHall", w, h, col);
      columns = new Columns("townHall", w, h, col);
      doorW= dh * random(0.3f, 0.4f);
      float doorXPos = random((doorW*0.5f), w-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeHouseWindows();
      //String ty, float _w, float _h, float _x, float _y, color _col
      float hMultipier = random(2.0f, 2.999f);
      tower1 = new Minaret("mosque", w*0.2f, h*hMultipier, x, y-(h*(hMultipier-1)), col);
      //tower2 = new Minaret("mosque", w*0.2, h*hMultipier, x+(w*0.8), y-(h*(hMultipier-1)), col);

      //hack to make now winow
      makeWindows("mosque", 1.2f, 1.4f, 0.3f, 0.4f, 0.2f, 0.4f, 0);
    } else if (type.equals("townHall")) {
      roof = new Roof("townHall", w, w*random(0.2f, 0.3f), roofCol);
      body = new Body("townHall", w, h, col);


      columns = new Columns("townHall", w, h, col);
      doorW= dh * random(1.3f, 1.4f);
      float doorXPos = (w*0.5f)-doorW*0.5f;
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeHouseWindows();

      //hack to make now winow
      makeWindows("townHall", 1.2f, 1.4f, 0.3f, 0.4f, 0.2f, 0.4f, 0);
    } else if (type.equals("factory")) {
      float roofHeight = w*random(0.05f, 0.1f);
      roof = new Roof("saw", w, roofHeight, roofCol);
      body = new Body("home", w, h, col);

      doorW= dh * random(0.5f, 1.6f);
      float doorXPos = random((doorW*0.5f), w-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);


      makeWindows("factory", 0.08f, 0.1f, 0.2f, 0.3f, 0.2f, 0.4f, 1);
      makeRoofDecoration(0, w*0.05f, w*0.06f);
    } else if (type.equals("shop")) {
      roof = new Roof("shop", w, w*random(0.1f, 0.2f), roofCol);
      body = new Body("home", w, h, col);
      float ah = h*(random(0.15f,0.2f));

      awning = new Awning("awning", x, y +h -dh -ah, w, ah, (int) random(10, 16), col);

      doorW= dh * random(0.5f, 1.0f);
      float doorXPos = random((doorW*0.1f), (0.5f*w)-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeFactoryWindows();
      makeWindows("shop", 0.4f, 0.45f, 0.3f, 0.35f, 0.05f, 0.1f, 0);
    } else if (type.equals("towerblock")) {
      float roofHeight =  w*random(0.1f, 0.2f);
      roof = new Roof("shop", w, roofHeight, roofCol);
      body = new Body("home", w, h, col);
      doorW= dh * random(0.5f, 1.0f);

      float ah = h*0.03f;
      float aw = doorW*1.3f;///w*0.35;

      awning = new Awning("awning", x + ((w*0.5f)-(aw*0.5f)), y +h -dh -ah, aw, ah, (int)random(1, 3), col);

      float doorXPos = (w*0.5f)-(doorW*0.5f);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeFactoryWindows();
      makeWindows("towerblock", 0.2f, 0.3f, 0.1f, 0.15f, 0.05f, 0.1f, 0);

      makeRoofDecoration(roofHeight, w*0.25f, w*0.3f);
    }

    x = _x;
    y = _y;
  }
  public void display() {
    pushStyle();
    pushMatrix();
    translate(x, y-h);
    translate(0, h-(h*scaleY));
    scale(1, scaleY);

    if (type.equals("home")) {
      body.display();
      for (int i=0; i<windows.length; i++) {
        windows[i].display();
      }
      door.display();
      roof.display();
    } else if (type.equals("towerblock")) {
      body.display();
      for (int i=0; i<windows.length; i++) {
        windows[i].display();
      }
      decoration.display();
      door.display();
      roof.display();
      awning.display();
    } else if (type.equals("factory")) {
      body.display();
      for (int i=0; i<windows.length; i++) {
        windows[i].display();
      }
      door.display();
      decoration.display();
      roof.display();
    } else if (type.equals("townHall")) {
      body.display();
      for (int i=0; i<windows.length; i++) {
        windows[i].display();
      }
      door.display();
      columns.display();
      roof.display();
    } else if (type.equals("mosque")) {
      body.display();
      for (int i=0; i<windows.length; i++) {
        windows[i].display();
      }
      tower1.display();
      //  tower2.display();
      door.display();
      columns.display();
      roof.display();
    } else if (type.equals("shop")) {
      body.display();
      for (int i=0; i<windows.length; i++) {
        windows[i].display();
      }
      door.display();
      awning.display();
      roof.display();
    }


    //if (type.equals("towerblock")||  type.equals("factory")) {
    //  decoration.display();
    //}

    //if (!type.equals("townHall")) body.display();

    //for (int i=0; i<windows.length; i++) {
    //  windows[i].display();
    //}

    //door.display();
    //if ( type.equals("shop")||  type.equals("towerblock")) {
    //  awning.display();
    //}
    //if ( type.equals("townHall")) {
    //  columns.display();
    //}
    //if (type.equals("mosque")) {

    //  tower1.display();
    //  //  tower2.display();
    //  columns.display();
    //}
    //roof.display();
    popMatrix();
    popStyle();
  }
  public void makeRoofDecoration(float roofHeight, float decorationWidth, float decorationHeight) {

    String decType = "";
    float chooser = random(0.0f, 100);
    if (chooser<30) {
      decType="waterTower";
    } else if (chooser>=30 && chooser <65){
      decType="cellMast";
    }
    else{
      decType="aerial";
    }
    decoration = new RoofDecoration(decType, random(0, w*0.5f), 0-roofHeight, decorationWidth, decorationHeight, col   );//float _x, float _y, float _w, float _h,  color _col)
  }

  //x and y values are top left coord
  public void drawSquaresOverlap(int x, int y, int w, int h, int x1, int y1, int w1, int h1) {
    fill(200, 100, 100);
    rect(x, y, w, h);
    fill(100, 100, 100);
    rect(x1, y1, w1, h1);
  }
  public boolean doOverlap(PVector l1, PVector r1, PVector l2, PVector r2) {
    // If one rectangle is on left side of other
    if (l1.x >= r2.x || l2.x >= r1.x)
      return false;

    // If one rectangle is above other
    //if (l1.y <= r2.y || l2.y <= r1.y)
    if (r1.y <= l2.y || r2.y <= l1.y)
      return false;

    return true;
  }


  public void makeWindows(String windowType, float wl, float wh, float hl, float hh, float sl, float sh, int forceNumWindows) {
    int windowW = (int)random(w*wl, w*wh);
    int windowH = (int)random(h*hl, h*hh);
    float windowToSpaceRatio = random(sl, sh);

    int numWindowsX = PApplet.parseInt(w/(windowW+(windowToSpaceRatio*windowW)));
    int numWindowsY = 0;
    if (forceNumWindows==1) {
      numWindowsY = 1;
    } else {
      numWindowsY = PApplet.parseInt(h/(windowH +(windowToSpaceRatio*windowH)));
    }

    windows = new Window[numWindowsX* numWindowsY];

    //TODO rename windowtospaceratio as windowspace
    float windowWSpace = windowW* windowToSpaceRatio;
    float windowHSpace = windowH* windowToSpaceRatio;
    //total x space occupied by windows and spaces
    float totalWindowWSpace =  (numWindowsX*windowW) + ( (numWindowsX-1)*windowWSpace );
    float totalWindowHSpace =  (numWindowsY*windowH) + ( (numWindowsY-1)*windowHSpace );
    float xOffset = (w -totalWindowWSpace) *0.5f;
    float yOffset = (h -totalWindowHSpace) *0.5f;
    int index = 0;
    for (int i=0; i<numWindowsX; i++) {
      for (int j=0; j<numWindowsY; j++) {


        float x = xOffset +( i *(windowW+( windowW * windowToSpaceRatio)) );
        float y = yOffset +( j *( windowH+ (windowH * windowToSpaceRatio)) );

        PVector l1 = new PVector(x, y);
        PVector r1 = new PVector(x+windowW, y+windowH);
        PVector l2 = new PVector(door.x, door.y);
        PVector r2 = new PVector(door.x+door.w, door.y+door.h);

        PVector l3 = new PVector(0, 0);
        PVector r3 = new PVector(0, 0);

        if (type.equals("shop")) {
          l3 = new PVector(awning.x, awning.y);
          r3 = new PVector(awning.x+awning.w, awning.y+awning.h);
          if (doOverlap( l1, r1, l3, r3)||doOverlap( l1, r1, l2, r2) ) {
            // if (doOverlap( l1, r1, l2, r2) ||doOverlap( l1, r1, l3, r3) ) {
            windows[index] = new Window(windowType, 0, 0, x, y, color(0, random(0, 10), random(200, 255)));
          } else {
            windows[index] = new Window(windowType, windowW, windowH, x, y, color(0, random(0, 10), random(200, 255)));
          }
        } else {
          if (doOverlap( l1, r1, l2, r2) ) {
            // if (doOverlap( l1, r1, l2, r2) ||doOverlap( l1, r1, l3, r3) ) {
            windows[index] = new Window(windowType, 0, 0, x, y, color(0, random(0, 10), random(200, 255)));
          } else {
            windows[index] = new Window(windowType, windowW, windowH, x, y, color(0, random(0, 10), random(200, 255)));
          }
        }
        index++;
      }
    }
  }
}
class Columns {
  float x, y, w, h;
  String type;
  int col;
  WonkyRect wonkyRect;
  WonkyRect [] rects;
  int columnColour ;
  Columns(String _ty, float _w, float _h, int _col) {
    col = _col;
    w = _w;
  
    h = _h;
    type = _ty;
    int strokeCol  =color(23, 69, 17);
    float saturation =100;
     columnColour = color(random(360),saturation(col),brightness(col));
     //col =color(random(360), random(saturation-10, saturation+10), random(75, 85));
    if (type.equals("townHall")) {
      wonkyRect  = new WonkyRect(w*0.1f, 0, w*0.8f, h, 5, random(0.1f, 1.5f), col, strokeCol);
      rects = new WonkyRect[PApplet.parseInt(random(4, 7))+2];
      float stepHeight = h*0.1f;
      //bottom step
      rects[0] = new  WonkyRect(0, h-stepHeight, w, stepHeight, 5, random(0.1f, 0.3f), col, strokeCol);
      //top step
      rects[1] = new  WonkyRect(w*0.05f, h-(2*stepHeight), w*0.9f, stepHeight, 5, random(0.1f, 0.3f), col, strokeCol);

      //now the columns
      float columnWidth = w *0.1f;
      float columnSpace = w/(rects.length-1.5f);
      for (int i=2; i<rects.length; i++) {
        rects[i] = new WonkyRect((i-1.5f)*columnSpace, 0, columnWidth, h-(2*stepHeight), 5, random(0.1f, 0.3f), columnColour, strokeCol);
      }
    } else {
      wonkyRect  = new WonkyRect(0, 0, w*0.9f, h, 5, random(0.1f, 1.5f), col, strokeCol);
    }
  }
  public void display() {
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
class Door {
  String type;
  float w;
  float h;
  float x;
  float y;
  float numTris;
  int col;
  WonkyRect wonkyRect;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Door(String ty, float _w, float _h, float _x, float _y, int _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    int strokeCol  =color(23, 69, 17);
  
    wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1f, 0.5f), col, strokeCol);
  }

  public void display() {
    pushStyle();
    pushMatrix();
    fill(col);

    //rect(x,y,w,h);    
    translate(x, y);
    wonkyRect.display();
    popStyle();
    popMatrix();
  }
}
class Minaret {
  String type;
  float w;
  float h;
  float x;
  float y;
  float numTris;
  int col;
  WonkyRect tower;
  WonkySemi dome;
  Window window;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Minaret(String ty, float _w, float _h, float _x, float _y, int _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    int strokeCol  =color(23, 69, 17);
  
    tower  = new WonkyRect(0, 0, w, h, 5, random(0.1f, 0.5f), col, strokeCol);
    //String ty, float _w, float _h, float _x, float _y, color _col
    int windowColour =  color(0, random(0, 10), random(200, 255));
    window  = new Window("minaret", w*0.5f, h*0.2f, x+(w*0.25f),h*0.2f, windowColour);
    //float _x, float _y, float _r, int _subDivisions, float _wonk, color _col, color _strokeCol
    dome = new WonkySemi(x,0,w*0.5f,8,random(0.1f, 0.5f),col,strokeCol);
  }

  public void display() {
    pushStyle();
    pushMatrix();
    fill(col);

    //rect(x,y,w,h);    
    translate(x, y);
    tower.display();
    dome.display();
    window.display();
    popStyle();
    popMatrix();
  }
}
class Roof {
  String type;
  float w;
  float h;
  int numTris;
  int col;
  WonkyTri tri;
  WonkyTri [] tris;
  WonkyRect wonkyRect;
  WonkySemi semi;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Roof(String ty, float _w, float _h, int _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    numTris = PApplet.parseInt(random(5, 9));
    int strokeCol  =color(23, 69, 17);
    if (type.equals("triangle")) {
      tri = new WonkyTri(0, 0, w/2, -h, w, 0, 5, 0.3f, col, strokeCol );
      float hi = h*random(0.7f, 1.2f);

      float wi = w*random(0.1f, 0.3f);
      wonkyRect  = new WonkyRect(random( 0, w-wi), -hi, wi, hi, 5, random(0.1f, 0.3f), col, strokeCol);
    } else if (type.equals("townHall")) {

      float hi = h*random(0.3f, 0.4f);
      tri = new WonkyTri(0, -hi, w/2, -h, w, -hi, 5, 0.3f, col, strokeCol );

      wonkyRect  = new WonkyRect(0, -hi, w, hi, 5, random(0.1f, 0.3f), col, strokeCol);
    } else if (type.equals("saw")) {
      float hi = h*random(1.9f, 3.9f);

      float wi = w*random(0.02f, 0.08f);
      wonkyRect  = new WonkyRect(random( 0, w-wi), -hi, wi, hi, 5, random(0.1f, 0.3f), col, strokeCol);

      float roofSectionWidth = w/numTris;

      tris = new WonkyTri[numTris];
      boolean leanLeft = true;
      if (random(1)>=0.5f) leanLeft = false;
      for (int i=0; i<numTris; i++) {
        if (leanLeft) {
          tris[i]  = new WonkyTri( i*roofSectionWidth, 0, (i*roofSectionWidth)+roofSectionWidth, -h, (i*roofSectionWidth)+roofSectionWidth, 0, 5, 0.3f, col, strokeCol);
        } else {
          tris[i]  = new WonkyTri( i*roofSectionWidth, 0, (i*roofSectionWidth), -h, (i*roofSectionWidth)+roofSectionWidth, 0, 5, 0.3f, col, strokeCol);
        }
      }
    } else if (type.equals("shop")) {
      wonkyRect  = new WonkyRect(0, -h, w, h, 5, random(0.1f, 0.3f), col, strokeCol);
      
    }
     else if (type.equals("mosque")) {
       semi = new WonkySemi(0,0,w*0.5f,15 ,random(0.1f, 0.3f), col, strokeCol);
     }
  }

  public void display() {
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
class RoofDecoration {
  String type;
  float w;
  float h;
  float x;
  float y;

  int col;
  //WonkyRect wonkyRect;
  WonkyRect [] rects;
  WonkyTri tri;

  RoofDecoration(String ty, float _x, float _y, float _w, float _h, int _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;

    int strokeCol  =color(23, 69, 17);


    // wonkyRect  = new WonkyRect(0, 0, w, h, 15, random(0.1, 0.5), col, strokeCol);

    if (type.equals("waterTower")) {
      rects =  new WonkyRect[3];
      //mainBody
      //rects[0]= new WonkyRect(0, -h, w, h, 5, random(0.1, 0.2), col, strokeCol);

      rects[0]= new WonkyRect(0, -h, w, h*0.7f, 5, random(0.1f, 0.2f), col, strokeCol);
      //left leg
      rects[1]= new WonkyRect(w*0.2f, -h*0.3f, w*0.2f, h*0.3f, 5, random(0.1f, 0.2f), col, strokeCol);
      //right leg
      rects[2]= new WonkyRect(w-(w*0.4f), -h*0.3f, w*0.2f, h*0.3f, 5, random(0.1f, 0.2f), col, strokeCol);

      float triW = w*1.3f;
      float triX1 = 0-(w*0.15f);
      float triX2 = w/2;
      float triX3 = w+(w*0.15f);
      tri = new WonkyTri(triX1, -h, triX2, -h*1.3f, triX3, -h, 4, 0.1f, col, strokeCol );
      //WonkyTri(float _x, float _y, float _x1, float _y1, float _x2, float _y2, int _subDivisions, float _wonk, color _col, color _strokeCol)
    } else if (type.equals("aerial")) {
      w*=0.7f;
      //float triX1 = 0;
      //float triX2 = w/2;
      //float triX3 = w;
      //tri = new WonkyTri(triX1, 0, triX2, -h, triX3, 0, 4, 0.1, col, strokeCol );

      rects =  new WonkyRect[4];

      rects[0]= new WonkyRect(0, -h*0.8f, w, h*0.1f, 5, random(0.1f, 0.2f), col, strokeCol);
      rects[1]= new WonkyRect(0, -h*1.1f, w*0.2f, h*0.5f, 5, random(0.1f, 0.2f), col, strokeCol);
      rects[2]= new WonkyRect(w, -h*1.1f, w*0.2f, h*0.5f, 5, random(0.1f, 0.2f), col, strokeCol);
      float mastWidth = w*0.2f;
      rects[3]= new WonkyRect((w/2)-(mastWidth*0.5f), -h, mastWidth, h, 5, random(0.1f, 0.2f), col, strokeCol);
    }
    else if (type.equals("cellMast")) {
      w*=0.7f;
      float triX1 = 0;
      float triX2 = w/2;
      float triX3 = w;
      tri = new WonkyTri(triX1, 0, triX2, -h, triX3, 0, 4, 0.1f, col, strokeCol );

      rects =  new WonkyRect[3];

      rects[0]= new WonkyRect(0, -h*0.8f, w, h*0.1f, 5, random(0.1f, 0.2f), col, strokeCol);
      rects[1]= new WonkyRect(0, -h*1.1f, w*0.2f, h*0.5f, 5, random(0.1f, 0.2f), col, strokeCol);
      rects[2]= new WonkyRect(w, -h*1.1f, w*0.2f, h*0.5f, 5, random(0.1f, 0.2f), col, strokeCol);
    }
  }

  public void display() {
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
class Window {
  String type;
  float w;
  float h;
  float x;
  float y;
  float numTris;
  int col;
  WonkyRect wonkyRect;
  WonkyRect [] panes;
  //types include triangle, flat, saw, square, gabled , waraehouse , dome
  Window(String ty, float _w, float _h, float _x, float _y, int _col) {
    col = _col;//color(random(200,255),random(0,20),random(0,20))  ;//_col;
    type = ty;
    w = _w;
    h = _h;
    x = _x;
    y = _y;
    int strokeCol  =color(23, 69, 17);

    wonkyRect  = new WonkyRect(0, 0, w, h, 5, random(0.1f, 0.5f), col, strokeCol);
    if (type.equals("home")) {
      panes = new WonkyRect[4];
      strokeCol  =color(23, 69, 37);
      float paneW = w*0.35f;
      float paneH = h*0.35f;
      int paneColour = color(hue(col),saturation(col),brightness(col)-30);
      //top left
      panes[0] = new WonkyRect(w*0.1f, h*0.1f, paneW, paneH, 3, random(0.1f, 0.2f),paneColour, strokeCol);
      //top right
      panes[1] = new WonkyRect((w*0.2f)+paneW, h*0.1f, paneW, paneH, 3, random(0.1f, 0.2f),paneColour, strokeCol);
      //bottom left
      panes[2] = new WonkyRect(w*0.1f, (h*0.2f)+paneH, paneW, paneH, 3, random(0.1f, 0.2f), paneColour,strokeCol);
      //bottom right
      panes[3] = new WonkyRect((w*0.2f)+paneW, (h*0.2f)+paneH, paneW, paneH, 3, random(0.1f, 0.2f), paneColour, strokeCol);
    }
  }

  public void display() {
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
  public void settings() {  fullScreen(JAVA2D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "generative_buildings" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
