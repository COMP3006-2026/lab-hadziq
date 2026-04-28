/*
Modify your program for the exercise 3 tutorial 10 
that can draw 5 car objects 
with different sizes and/or colours.
*/

import shapes3d.*;
import shapes3d.utils.*;

Shape3D[] parts;
float angleX = -0.3;
float angleY = 0.4;

// Per-car configuration: x offset, z offset, scale, body color, cabin color
float[][] carPositions = {
  {   0,    0, 1.00},  // center, full size
  {-350, -120, 0.70},  // back-left, smaller
  { 350, -120, 0.85},  // back-right, medium
  {-300,  150, 0.60},  // front-left, smallest
  { 320,  140, 0.95}   // front-right, large
};

color[] chassisColors = {
  color(200,  40,  50),  // red
  color( 40, 160,  80),  // green
  color(230, 180,  40),  // yellow
  color( 60,  60,  70),  // dark gray
  color(180,  90, 200)   // purple
};

color[] cabinColors = {
  color( 60,  90, 160),  // blue
  color(180, 220, 240),  // light cyan
  color( 80,  50,  30),  // brown
  color(220, 220, 230),  // off-white
  color( 50,  30,  80)   // deep indigo
};

void setup() {
  size(900, 650, P3D);
  buildCars();
}

void draw() {
  background(210, 220, 235);
  lights();
  
  // Camera orbit
  translate(width/2, height/2, 0);
  if (mousePressed) {
    angleY = map(mouseX, 0, width, -PI, PI);
    angleX = map(mouseY, 0, height, -PI, PI);
  }
  rotateX(angleX);
  rotateY(angleY);
  
  for (Shape3D part : parts) {
    part.draw(g);
  }
}

void buildCars() {
  // 7 parts per car * 5 cars = 35 parts
  parts = new Shape3D[7 * 5];
  int idx = 0;
  
  for (int c = 0; c < 5; c++) {
    float ox = carPositions[c][0];
    float oz = carPositions[c][1];
    float s  = carPositions[c][2];
    color chassisCol = chassisColors[c];
    color cabinCol   = cabinColors[c];
    
    idx = buildCar(idx, ox, oz, s, chassisCol, cabinCol);
  }
}

// Builds one car at (ox, 0, oz) scaled by s, with given body & cabin colors.
// Returns the next free index in parts[].
int buildCar(int idx, float ox, float oz, float s, color chassisCol, color cabinCol) {
  
  // --- 1. Chassis ---
  Box chassis = new Box(220 * s, 50 * s, 90 * s);
  chassis.moveTo(ox, 0, oz);
  chassis.fill(chassisCol);
  chassis.stroke(color(40));
  chassis.strokeWeight(1);
  chassis.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = chassis;
  
  // --- 2. Cabin ---
  Box cabin = new Box(130 * s, 45 * s, 80 * s);
  cabin.moveTo(ox - 10 * s, -47 * s, oz);
  cabin.fill(cabinCol);
  cabin.stroke(color(30));
  cabin.strokeWeight(1);
  cabin.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = cabin;
  
  // --- 3-6. Four wheels ---
  float wheelY        = 30.0 * s;
  float wheelXOffset  = 75.0 * s;
  float wheelZOffset  = 50.0 * s;
  float wheelR        = 22.0 * s;
  float wheelThick    =  8.0 * s;
  
  float[][] wheelPos = {
    {ox - wheelXOffset, wheelY, oz + wheelZOffset},
    {ox - wheelXOffset, wheelY, oz - wheelZOffset},
    {ox + wheelXOffset, wheelY, oz + wheelZOffset},
    {ox + wheelXOffset, wheelY, oz - wheelZOffset}
  };
  
  for (int i = 0; i < 4; i++) {
    Ellipsoid wheel = new Ellipsoid(wheelR, wheelR, wheelThick, 16, 16);
    wheel.moveTo(wheelPos[i][0], wheelPos[i][1], wheelPos[i][2]);
    wheel.fill(color(30));
    wheel.stroke(color(160));
    wheel.strokeWeight(1);
    wheel.drawMode(Shape3D.SOLID | Shape3D.WIRE);
    parts[idx++] = wheel;
  }
  
  // --- 7. Front lights bar ---
  Box lights = new Box(10 * s, 12 * s, 60 * s);
  lights.moveTo(ox - 115 * s, -5 * s, oz);
  lights.fill(color(255, 245, 180));
  lights.stroke(color(200, 180, 80));
  lights.strokeWeight(1);
  lights.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = lights;
  
  return idx;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    angleX = -0.3;
    angleY = 0.4;
  }
}
