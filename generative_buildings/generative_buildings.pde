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
WonkyTri tri;
PImage img;
int joyStickVal = 0;
MountainRange mountains;
MountainRange mountainsDistance;
boolean squash = false;
boolean unSquash = false;
boolean runSerial = false;
void setup() {
  size(1200, 800, JAVA2D);
  if (runSerial) {
    String portName = Serial.list()[3];
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

  img = loadImage("72.png");
  float saturation = 25;
  color mountainCol  =color(random(300, 330), random(saturation-10, saturation+10), random(75, 85));

  mountains = new MountainRange(0, int(baseLine), width, int(height*0.2), 300, mountainCol);
  mountainCol  =color(random(300, 330), random(saturation-20, saturation), random(75, 85));
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
  float scaleFactor  = map(mouseY, 0, height, 0, 6);
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
      squash=false;
    }
  }
}
void keyPressed() {

  if (key=='a') {
    println("a");
    squash = true;
  } else if (key=='a') {
  } else if (key=='c') {
  }
}
void createLines() {
  for (int i=0; i<lines.length; i++) {
    lines[i]= new BLine(baseLine, 40, map(i, 0, lines.length, 10, 60), 60);
  }
}
void squashAll() {

  for (int i=0; i<lines.length; i++) {
    lines[i].squash();
  }
}
boolean allBuildingsAreSquashed() {
  boolean areSquashed = true;
  for (int i=0; i<lines.length; i++) {
    if (!lines[i].allBuildingsAreSquashed()) areSquashed=false;
  }
  return areSquashed;
}

void serialEvent(Serial thisPort) {
  //int inByte = thisPort.read();
  String inString = thisPort.readString();
  //println(inString);
  if (splitTokens(inString, ":").length==2) {

    if (splitTokens(inString, ":")[0].equals("A")) {
      //   println("got serial",int(splitTokens(inString,":")[1].trim()));
      joyStickVal = int(splitTokens(inString, ":")[1].trim());
    }
  }
}
