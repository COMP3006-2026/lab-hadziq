/*
Construct a brick room (4 sides), a table and a chair. 
The table and a chair are locating inside the room. 
Add textures to the wall, 
table and the chair to make the scene more realistic.
*/

import shapes3d.utils.*;
import shapes3d.*;
import peasy.*;

PeasyCam cam;
PGraphics pg;

// Room parts
Box floor, wallN, wallS, wallE, wallW;

// Table: top + 4 legs
Box tableTop;
Box[] tableLegs = new Box[4];

// Chair: seat + 4 legs + backrest
Box chairSeat, chairBack;
Box[] chairLegs = new Box[4];

// Textures
PImage brickImg, woodImg, floorImg;

// Scene dimensions
float roomSize = 600;
float roomHeight = 400;

void setup() {
  size(1000, 800, P3D);
  pg = createGraphics(1000, 800, P3D);
  cam = new PeasyCam(this, pg, 700);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1500);
  
  // Load textures
  brickImg   = loadImage("data/brick.jpg");
  woodImg    = loadImage("data/wood.jpg");
  floorImg   = loadImage("data/floor.jpg");
  
  buildRoom();
  buildTable();
  buildChair();
}

void buildRoom() {
  // Floor at y = roomHeight/2 (downward in Processing's Y)
  floor = new Box(roomSize, 10, roomSize);
  floor.texture(floorImg);
  floor.moveTo(0, roomHeight/2, 0);
  floor.drawMode(Shape3D.TEXTURE);
  
  // Four brick walls
  // North wall (back, -Z side)
  wallN = new Box(roomSize, roomHeight, 10);
  wallN.texture(brickImg);
  wallN.moveTo(0, 0, -roomSize/2);
  wallN.drawMode(Shape3D.TEXTURE);
  
  // South wall (front, +Z side)
  wallS = new Box(roomSize, roomHeight, 10);
  wallS.texture(brickImg);
  wallS.moveTo(0, 0, roomSize/2);
  wallS.drawMode(Shape3D.TEXTURE);
  
  // East wall (+X side)
  wallE = new Box(10, roomHeight, roomSize);
  wallE.texture(brickImg);
  wallE.moveTo(roomSize/2, 0, 0);
  wallE.drawMode(Shape3D.TEXTURE);
  
  // West wall (-X side)
  wallW = new Box(10, roomHeight, roomSize);
  wallW.texture(brickImg);
  wallW.moveTo(-roomSize/2, 0, 0);
  wallW.drawMode(Shape3D.TEXTURE);
}

void buildTable() {
  // Table sits on the floor. Floor top is at y = roomHeight/2 - 5.
  // Table top is at height ~140 above floor, 10 thick.
  float floorTop = roomHeight/2 - 5;
  float tableTopThickness = 10;
  float tableHeight = 140;
  float tableTopY = floorTop - tableHeight + tableTopThickness/2;
  
  float tableW = 200, tableD = 120;
  
  // Table top
  tableTop = new Box(tableW, tableTopThickness, tableD);
  tableTop.texture(woodImg);
  tableTop.moveTo(0, tableTopY, 0);
  tableTop.drawMode(Shape3D.TEXTURE);
  
  // Four legs: positioned at corners, running from floor up to underside of top
  float legSize = 12;
  float legHeight = tableHeight - tableTopThickness;
  float legY = floorTop - legHeight/2;
  
  float legOffsetX = tableW/2 - legSize;
  float legOffsetZ = tableD/2 - legSize;
  
  float[][] legPos = {
    { legOffsetX, legY,  legOffsetZ},
    { legOffsetX, legY, -legOffsetZ},
    {-legOffsetX, legY,  legOffsetZ},
    {-legOffsetX, legY, -legOffsetZ}
  };
  
  for (int i = 0; i < 4; i++) {
    tableLegs[i] = new Box(legSize, legHeight, legSize);
    tableLegs[i].texture(woodImg);
    tableLegs[i].moveTo(legPos[i][0], legPos[i][1], legPos[i][2]);
    tableLegs[i].drawMode(Shape3D.TEXTURE);
  }
}

void buildChair() {
  // Chair placed in front of the table, offset along +Z
  float chairX = 0;
  float chairZ = 100;    // away from table on +Z side
  
  float floorTop = roomHeight/2 - 5;
  float seatThickness = 8;
  float seatHeight = 80;       // top of seat above floor
  float seatY = floorTop - seatHeight + seatThickness/2;
  float seatW = 70, seatD = 70;
  
  // Seat
  chairSeat = new Box(seatW, seatThickness, seatD);
  chairSeat.texture(woodImg);
  chairSeat.moveTo(chairX, seatY, chairZ);
  chairSeat.drawMode(Shape3D.TEXTURE);
  
  // Four chair legs
  float legSize = 8;
  float legHeight = seatHeight - seatThickness;
  float legY = floorTop - legHeight/2;
  float legOffsetX = seatW/2 - legSize;
  float legOffsetZ = seatD/2 - legSize;
  
  float[][] legPos = {
    {chairX + legOffsetX, legY, chairZ + legOffsetZ},
    {chairX + legOffsetX, legY, chairZ - legOffsetZ},
    {chairX - legOffsetX, legY, chairZ + legOffsetZ},
    {chairX - legOffsetX, legY, chairZ - legOffsetZ}
  };
  
  for (int i = 0; i < 4; i++) {
    chairLegs[i] = new Box(legSize, legHeight, legSize);
    chairLegs[i].texture(woodImg);
    chairLegs[i].moveTo(legPos[i][0], legPos[i][1], legPos[i][2]);
    chairLegs[i].drawMode(Shape3D.TEXTURE);
  }
  
  // Backrest: sits on top of the back edge of the seat, extends upward
  float backW = seatW;
  float backH = 80;
  float backThickness = 6;
  float backY = seatY - seatThickness/2 - backH/2;    // above the seat
  float backZ = chairZ + seatD/2 - backThickness/2;   // at back edge (+Z side)
  
  chairBack = new Box(backW, backH, backThickness);
  chairBack.texture(woodImg);
  chairBack.moveTo(chairX, backY, backZ);
  chairBack.drawMode(Shape3D.TEXTURE);
}

void draw() {
  pg.beginDraw();
  pg.background(20);
  
  // Warm interior lighting — one ceiling light + soft ambient
  //pg.ambientLight(80, 75, 70);
  //pg.pointLight(255, 240, 210, 0, -roomHeight/2 + 50, 0);
  pg.lights();
  
  // Draw the room
  floor.draw(pg);
  wallN.draw(pg);
  wallS.draw(pg);
  wallE.draw(pg);
  wallW.draw(pg);
  
  // Draw the table
  tableTop.draw(pg);
  for (Box leg : tableLegs) leg.draw(pg);
  
  // Draw the chair
  chairSeat.draw(pg);
  chairBack.draw(pg);
  for (Box leg : chairLegs) leg.draw(pg);
  
  pg.endDraw();
  
  cam.getState().apply(pg);
  image(pg, 0, 0);
}
