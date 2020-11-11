import processing.serial.*;
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
float globalSaturation=40;
float globalBrightness=85;
float zoomSpeed = 0.003;
WonkyTri tri;
PImage img;
PImage frame;
float joyStickVal = 3.0;
MountainRange mountains;
MountainRange mountainsDistance;
boolean squash = false;
boolean unSquash = false;
boolean runSerial = false;
void setup() {
  //size(1200, 800, JAVA2D);
  fullScreen(JAVA2D);
  noCursor();
  if (runSerial) {
    String portName = Serial.list()[1];
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil(10);
  }
  baseLine = height*0.4;
  colorMode(HSB, 360, 100, 100);

  lines = new BLine [10];
  createLines();

  //line = new BLine(baseLine, 40, 10,60);
  //line2 = new BLine(baseLine, 40, 40,60);
  smooth();
  color strokeCol  =color(23, 69, 17);

  img = loadImage("paper_texture_mid.png");
  frame = loadImage("bamboo_frame.png");
  float mountainSaturation = 25;
  color mountainCol  =color(random(300, 330), random(mountainSaturation-10, mountainSaturation+10), random(75, 85));

  mountains = new MountainRange(0, int(baseLine), width, int(height*0.2), 300, mountainCol);
  mountainCol  =color(random(300, 330), random(mountainSaturation-20, mountainSaturation), random(75, 85));
  mountainsDistance = new MountainRange(0, int(baseLine), width, int(height*0.25), 300, mountainCol);
}
void scaleFromCentre(float sc, float baseLine) {
  translate(width/2, baseLine);
  scale(sc );
  // translate(0,0,map(mouseY,0,height,0,600));
  translate(-width/2, -baseLine);
  translate(-width*2, 0);
}
void draw() {
  background(255);
  //float scaleFactor  = map(mouseY, 0, height, 0, 6);
  //joyStickVal = constrain(joyStickVal,170,1023);
  float scaleFactor  = joyStickVal ;//map(joyStickVal, 170, 1023, 0, 6);


  mountainsDistance.display();
  mountains.display();


  for (int i=0; i<lines.length; i++) {
    pushMatrix();
    float sc = scaleFactor*i*i*0.05;
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
  image(frame,0,0,width,height);
}
void keyPressed() {

  if (key=='a' && !unSquash) {
    println("a");
    squash = true;
  } else if (key=='b' && !squash) {
    unSquash = true;
  } else if (key=='c') {
    regenerateBuildings();
  }
}
void regenerateBuildings() {
  lines = new BLine [10];
  createLines();
  for (int i=0; i<lines.length; i++) {
    lines[i].setToSquashed();
  }
}
void drawPictureFrame() {
  float frameWidth = 50;
  fill(23, 47, 50);
  pushStyle();
  //top side
  beginShape();
  vertex(0, 0);
  vertex(width, 0);
  vertex(width-frameWidth, frameWidth);
  vertex(frameWidth, frameWidth);
  vertex(0, 0);
  endShape();
  //right side
  beginShape();
  vertex(width, 0);
  vertex(width, height);
  vertex(width-frameWidth, height - frameWidth);
  vertex(width -frameWidth, frameWidth);
  vertex(width, 0);
  endShape();
  popStyle();
}
void createLines() {

  for (int i=0; i<lines.length; i++) {
    lines[i]= new BLine(baseLine, 40, map(i, 0, lines.length, 10, globalSaturation), globalBrightness, 60);
  }
}
void squashAll() {

  for (int i=0; i<lines.length; i++) {
    lines[i].squash();
  }
}
void unSquashAll() {

  for (int i=0; i<lines.length; i++) {
    lines[i].unSquash();
  }
}
boolean allBuildingsAreSquashed() {
  boolean areSquashed = true;
  for (int i=0; i<lines.length; i++) {
    if (!lines[i].allBuildingsAreSquashed()) areSquashed=false;
  }
  return areSquashed;
}
boolean allBuildingsAreUnSquashed() {
  boolean areUnSquashed = true;
  for (int i=0; i<lines.length; i++) {
    if (!lines[i].allBuildingsAreUnSquashed()) areUnSquashed=false;
  }
  return areUnSquashed;
}

void serialEvent(Serial thisPort) {
  //int inByte = thisPort.read();
  String inString = thisPort.readString();
  //println(inString);
  if (splitTokens(inString, ":").length==2) {

    if (splitTokens(inString, ":")[0].equals("J")) {
      println("got serial", int(splitTokens(inString, ":")[1].trim()));
      int val = int(splitTokens(inString, ":")[1].trim());
      int centrePoint = 520;
      if (val<centrePoint -20) {
        if (joyStickVal>zoomSpeed) {
          if (val<255) {
            joyStickVal-=(2*zoomSpeed);
          } else {
            joyStickVal-=zoomSpeed;
          }
        }
      }
      if (val>centrePoint+20) {
        if (joyStickVal<6) {
          if (val<900) {
            joyStickVal+=zoomSpeed;
          } else {
            joyStickVal+=(zoomSpeed*2);
          }
        }
      }
    } else if (splitTokens(inString, ":")[0].equals("B")) {
      int button = int(splitTokens(inString, ":")[1].trim());
      //  println("got serial",button);
      if (button==1&&!squash && !unSquash) {
        squash=true;
      }
      //  squash=true;
    }
  }
}
