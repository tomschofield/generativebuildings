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
  float scaleY = 1.0;
  float dh;
  float scaleSpeed;
  String type;
  color col;
  //basic typologies are sky scraper, shop, home, mosque,

  Building(float _x, float _y, float _w, float _h, float _dh, String _ty, color _col) {
    col = _col;
    w = _w;
    h = _h;
    dh = _dh;
    type = _ty;
    scaleSpeed = random(0.05, 0.1);
    font = loadFont("Dialog-18.vlw");
    textFont(font, 18);
    color roofCol  =color(random(80, 90), random(5, 17), random(60, 75));
    color doorCol  =color(random(10, 30), random(5, 17), random(60, 75));
    float doorW=0;


    if (type.equals("home")) {
      roof = new Roof("triangle", w, w*random(0.2, 0.4), roofCol);
      body = new Body("home", w, h, col);

      doorW= dh * random(0.3, 0.4);
      float doorXPos = random((doorW*0.5), w-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeHouseWindows();
      makeWindows("home", 0.2, 0.4, 0.3, 0.4, 0.2, 0.4, 0);
    } else if (type.equals("mosque")) {
      roof = new Roof("mosque", w, w*random(0.3, 0.6), roofCol);
      body = new Body("townHall", w, h, col);
      columns = new Columns("townHall", w, h, col);
      doorW= dh * random(0.3, 0.4);
      float doorXPos = random((doorW*0.5), w-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeHouseWindows();
      //String ty, float _w, float _h, float _x, float _y, color _col
      float hMultipier = random(2.0, 2.999);
      tower1 = new Minaret("mosque", w*0.2, h*hMultipier, x, y-(h*(hMultipier-1)), col);
      //tower2 = new Minaret("mosque", w*0.2, h*hMultipier, x+(w*0.8), y-(h*(hMultipier-1)), col);

      //hack to make now winow
      makeWindows("mosque", 1.2, 1.4, 0.3, 0.4, 0.2, 0.4, 0);
    } else if (type.equals("townHall")) {
      roof = new Roof("townHall", w, w*random(0.2, 0.3), roofCol);
      body = new Body("townHall", w, h, col);


      columns = new Columns("townHall", w, h, col);
      doorW= dh * random(1.3, 1.4);
      float doorXPos = (w*0.5)-doorW*0.5;
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeHouseWindows();

      //hack to make now winow
      makeWindows("townHall", 1.2, 1.4, 0.3, 0.4, 0.2, 0.4, 0);
    } else if (type.equals("factory")) {
      float roofHeight = w*random(0.05, 0.1);
      roof = new Roof("saw", w, roofHeight, roofCol);
      body = new Body("home", w, h, col);

      doorW= dh * random(0.5, 1.6);
      float doorXPos = random((doorW*0.5), w-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);


      makeWindows("factory", 0.08, 0.1, 0.2, 0.3, 0.2, 0.4, 1);
      makeRoofDecoration(0, w*0.05, w*0.06);
    } else if (type.equals("shop")) {
      roof = new Roof("shop", w, w*random(0.1, 0.2), roofCol);
      body = new Body("home", w, h, col);
      float ah = h*(random(0.15,0.2));

      awning = new Awning("awning", x, y +h -dh -ah, w, ah, (int) random(10, 16), col);

      doorW= dh * random(0.5, 1.0);
      float doorXPos = random((doorW*0.1), (0.5*w)-doorW);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeFactoryWindows();
      makeWindows("shop", 0.4, 0.45, 0.3, 0.35, 0.05, 0.1, 0);
    } else if (type.equals("towerblock")) {
      float roofHeight =  w*random(0.1, 0.2);
      roof = new Roof("shop", w, roofHeight, roofCol);
      body = new Body("home", w, h, col);
      doorW= dh * random(0.5, 1.0);

      float ah = h*0.03;
      float aw = doorW*1.3;///w*0.35;

      awning = new Awning("awning", x + ((w*0.5)-(aw*0.5)), y +h -dh -ah, aw, ah, (int)random(1, 3), col);

      float doorXPos = (w*0.5)-(doorW*0.5);
      door = new Door("any", doorW, dh, doorXPos, h-dh, doorCol);
      // makeFactoryWindows();
      makeWindows("towerblock", 0.2, 0.3, 0.1, 0.15, 0.05, 0.1, 0);

      makeRoofDecoration(roofHeight, w*0.25, w*0.3);
    }

    x = _x;
    y = _y;
  }
  void display() {
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
  void makeRoofDecoration(float roofHeight, float decorationWidth, float decorationHeight) {

    String decType = "";
    float chooser = random(0.0, 100);
    if (chooser<30) {
      decType="waterTower";
    } else if (chooser>=30 && chooser <65){
      decType="cellMast";
    }
    else{
      decType="aerial";
    }
    decoration = new RoofDecoration(decType, random(0, w*0.5), 0-roofHeight, decorationWidth, decorationHeight, col   );//float _x, float _y, float _w, float _h,  color _col)
  }

  //x and y values are top left coord
  void drawSquaresOverlap(int x, int y, int w, int h, int x1, int y1, int w1, int h1) {
    fill(200, 100, 100);
    rect(x, y, w, h);
    fill(100, 100, 100);
    rect(x1, y1, w1, h1);
  }
  boolean doOverlap(PVector l1, PVector r1, PVector l2, PVector r2) {
    // If one rectangle is on left side of other
    if (l1.x >= r2.x || l2.x >= r1.x)
      return false;

    // If one rectangle is above other
    //if (l1.y <= r2.y || l2.y <= r1.y)
    if (r1.y <= l2.y || r2.y <= l1.y)
      return false;

    return true;
  }


  void makeWindows(String windowType, float wl, float wh, float hl, float hh, float sl, float sh, int forceNumWindows) {
    int windowW = (int)random(w*wl, w*wh);
    int windowH = (int)random(h*hl, h*hh);
    float windowToSpaceRatio = random(sl, sh);

    int numWindowsX = int(w/(windowW+(windowToSpaceRatio*windowW)));
    int numWindowsY = 0;
    if (forceNumWindows==1) {
      numWindowsY = 1;
    } else {
      numWindowsY = int(h/(windowH +(windowToSpaceRatio*windowH)));
    }

    windows = new Window[numWindowsX* numWindowsY];

    //TODO rename windowtospaceratio as windowspace
    float windowWSpace = windowW* windowToSpaceRatio;
    float windowHSpace = windowH* windowToSpaceRatio;
    //total x space occupied by windows and spaces
    float totalWindowWSpace =  (numWindowsX*windowW) + ( (numWindowsX-1)*windowWSpace );
    float totalWindowHSpace =  (numWindowsY*windowH) + ( (numWindowsY-1)*windowHSpace );
    float xOffset = (w -totalWindowWSpace) *0.5;
    float yOffset = (h -totalWindowHSpace) *0.5;
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
