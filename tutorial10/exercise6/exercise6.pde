/*
Add the transformation functions to question 2 so that the cars:
+ All cars move along lines (or curves) in 3D
+ Car 2 also rotates while moving
+ Car 3 increases its size to a maximum size while moving
+ Car 4 fades out onto the background while moving (you can use transparency to handle this property).
*/

import shapes3d.*;
import shapes3d.utils.*;

Shape3D[] parts;
int partsPerCar = 7;
int numCars = 5;

float angleX = -0.3;
float angleY = 0.4;

// Per-car configuration: x offset, z offset, scale (BASE values, never modified)
float[][] carPositions = {
  {   0,    0, 1.00},
  {-350, -120, 0.70},
  { 350, -120, 0.85},
  {-300,  150, 0.60},
  { 320,  140, 0.95}
};

color[] chassisColors = {
  color(200,  40,  50),
  color( 40, 160,  80),
  color(230, 180,  40),
  color( 60,  60,  70),
  color(180,  90, 200)
};

color[] cabinColors = {
  color( 60,  90, 160),
  color(180, 220, 240),
  color( 80,  50,  30),
  color(220, 220, 230),
  color( 50,  30,  80)
};

// Animation parameters
float t = 0;                  // master time, advances each frame
float pathSpeed = 0.012;      // how fast cars travel their paths

void setup() {
  size(900, 650, P3D);
  buildCars();
}

void draw() {
  background(210, 220, 235);
  lights();
  
  translate(width/2, height/2, 0);
  if (mousePressed) {
    angleY = map(mouseX, 0, width, -PI, PI);
    angleX = map(mouseY, 0, height, -PI, PI);
  }
  rotateX(angleX);
  rotateY(angleY);
  
  // Advance animation clock
  t += pathSpeed;
  
  // Update each car (path + per-car extra transforms) before drawing
  updateCar0();
  updateCar1();
  updateCar2();
  updateCar3();
  updateCar4();
  
  for (Shape3D part : parts) {
    part.draw(g);
  }
}

// ---------------- Path definitions ----------------
// Each returns the (x, y, z) world position the car should occupy at time t.
// The car's BASE position from carPositions[] is the path's anchor.

PVector pathCar0(float t) {
  // Horizontal circle around its base position, on the ground plane
  float r = 120;
  float bx = carPositions[0][0];
  float bz = carPositions[0][1];
  return new PVector(bx + r * cos(t), 0, bz + r * sin(t));
}

PVector pathCar1(float t) {
  // Straight line back-and-forth along X
  float bx = carPositions[1][0];
  float bz = carPositions[1][1];
  return new PVector(bx + 150 * sin(t * 1.3), 0, bz);
}

PVector pathCar2(float t) {
  // Figure-8 (lemniscate) on the ground plane
  float a = 140;
  float bx = carPositions[2][0];
  float bz = carPositions[2][1];
  float denom = 1 + sq(sin(t));
  return new PVector(bx + a * cos(t) / denom,
                     0,
                     bz + a * sin(t) * cos(t) / denom);
}

PVector pathCar3(float t) {
  // Rises and falls in Y while drifting in Z (a curve through 3D)
  float bx = carPositions[3][0];
  float bz = carPositions[3][1];
  return new PVector(bx,
                     -60 + 60 * sin(t * 1.5),
                     bz + 100 * sin(t));
}

PVector pathCar4(float t) {
  // Diagonal line bouncing through 3D
  float bx = carPositions[4][0];
  float bz = carPositions[4][1];
  return new PVector(bx + 120 * sin(t),
                     -40 * sin(t * 2),
                     bz + 80 * cos(t));
}

// ---------------- Per-car update functions ----------------

// Helper: rebuild ALL 7 parts of car c at a given world position, scale, rotation, and alpha.
// Rotation is around the car's vertical axis (Y), in radians.
void placeCar(int c, float ox, float oy, float oz, float s, float rotY, float alpha) {
  int base = c * partsPerCar;
  
  // Local-space offsets of each part relative to the chassis center, scaled by s.
  // (Same numbers as in buildCar(), but expressed as offsets so we can rotate them.)
  float[][] localOffsets = {
    {     0,      0,     0},  // chassis
    {-10*s, -47*s,     0},    // cabin
    {-75*s,  30*s,  50*s},    // wheel FL
    {-75*s,  30*s, -50*s},    // wheel FR
    { 75*s,  30*s,  50*s},    // wheel RL
    { 75*s,  30*s, -50*s},    // wheel RR
    {-115*s,-5*s,     0}      // lights
  };
  
  if (rotY > 0) {
    parts[base].rotateByY(rotY);
    parts[base+1].rotateByY(rotY);
  }
  
  if (s > 0) {
    parts[base].scale(s);
    parts[base+1].scale(s);
  }
  
  float cosR = cos(rotY);
  float sinR = sin(rotY);
  
  for (int i = 0; i < partsPerCar; i++) {
    float lx = localOffsets[i][0];
    float ly = localOffsets[i][1];
    float lz = localOffsets[i][2];
    
    // Rotate (lx, lz) around Y axis
    float rx =  lx * cosR + lz * sinR;
    float rz = -lx * sinR + lz * cosR;
    
    parts[base + i].moveTo(ox + rx, oy + ly, oz + rz);
  }
  
  // Apply transparency by re-applying fills with the alpha channel
  applyCarAlpha(c, alpha);
}

// Re-apply each part's fill with a given alpha (0..255).
// Scale parameter is unused here but kept for symmetry with placeCar.
void applyCarAlpha(int c, float alpha) {
  int base = c * partsPerCar;
  
  color chassisCol = setAlpha(chassisColors[c], alpha);
  color cabinCol   = setAlpha(cabinColors[c],   alpha);
  color wheelCol   = setAlpha(color(30),        alpha);
  color lightsCol  = setAlpha(color(255, 245, 180), alpha);
  
  parts[base + 0].fill(chassisCol);
  parts[base + 1].fill(cabinCol);
  for (int i = 0; i < 4; i++) parts[base + 2 + i].fill(wheelCol);
  parts[base + 6].fill(lightsCol);
}

color setAlpha(color c, float a) {
  return color(red(c), green(c), blue(c), a);
}

void updateCar0() {
  PVector p = pathCar0(t);
  placeCar(0, p.x, p.y, p.z, carPositions[0][2], 0, 255);
}

void updateCar1() {
  PVector p = pathCar1(t);
  placeCar(1, p.x, p.y, p.z, carPositions[1][2], 0, 255);
}

// Car 2: path + rotation around its own vertical axis
void updateCar2() {
  PVector p = pathCar2(t);
  float spin = t * 2.0;   // rotates as it travels
  placeCar(2, p.x, p.y, p.z, carPositions[2][2], spin, 255);
}

// Car 3: path + grows to a maximum size, then resets and grows again
void updateCar3() {
  PVector p = pathCar3(t);
  float baseS = carPositions[3][2];
  float maxS  = baseS * 2.5;
  // Cycle 0..1..0 over time using a sine, then map to [baseS, maxS]
  float phase = (sin(t * 0.7) + 1) * 0.5;   // 0..1
  float s = lerp(baseS, maxS, phase);
  placeCar(3, p.x, p.y, p.z, s, 0, 255);
}

// Car 4: path + fades in/out
void updateCar4() {
  PVector p = pathCar4(t);
  // Alpha cycles between ~30 (nearly invisible) and 255 (fully opaque)
  float phase = (sin(t * 0.9) + 1) * 0.5;   // 0..1
  float alpha = lerp(30, 255, phase);
  placeCar(4, p.x, p.y, p.z, carPositions[4][2], 0, alpha);
}

// ---------------- Build (unchanged structure) ----------------

void buildCars() {
  parts = new Shape3D[partsPerCar * numCars];
  int idx = 0;
  for (int c = 0; c < numCars; c++) {
    float ox = carPositions[c][0];
    float oz = carPositions[c][1];
    float s  = carPositions[c][2];
    idx = buildCar(idx, ox, oz, s, chassisColors[c], cabinColors[c]);
  }
}

int buildCar(int idx, float ox, float oz, float s, color chassisCol, color cabinCol) {
  Box chassis = new Box(220 * s, 50 * s, 90 * s);
  chassis.moveTo(ox, 0, oz);
  chassis.fill(chassisCol);
  chassis.stroke(color(40));
  chassis.strokeWeight(1);
  chassis.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = chassis;
  
  Box cabin = new Box(130 * s, 45 * s, 80 * s);
  cabin.moveTo(ox - 10 * s, -47 * s, oz);
  cabin.fill(cabinCol);
  cabin.stroke(color(30));
  cabin.strokeWeight(1);
  cabin.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = cabin;
  
  float wheelY       = 30.0 * s;
  float wheelXOffset = 75.0 * s;
  float wheelZOffset = 50.0 * s;
  float wheelR       = 22.0 * s;
  float wheelThick   =  8.0 * s;
  
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
