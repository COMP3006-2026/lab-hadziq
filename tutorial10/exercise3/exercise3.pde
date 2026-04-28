/*
Add the function so that a car can be picked. 
When a car is selected, its changes colour to a brighter colour. 
The colour is changed back to its original colour 
when another item is selected.
*/

import shapes3d.*;
import shapes3d.utils.*;

Shape3D[] parts;
int partsPerCar = 7;
int numCars = 5;

// Per-car configuration: x offset, z offset, scale
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

int selectedCar = -1;   // index of currently picked car, -1 = none

void setup() {
  size(900, 650, P3D);
  buildCars();
}

void draw() {
  background(210, 220, 235);
  lights();
  
  // Fixed view (no orbit) for easier picking
  translate(width/2, height/2, 0);
  rotateX(-0.3);
  rotateY(0.4);
  
  for (Shape3D part : parts) {
    part.draw(g);
  }
}

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
  
  // --- 1. Chassis ---
  Box chassis = new Box(220 * s, 50 * s, 90 * s);
  chassis.moveTo(ox, 0, oz);
  chassis.fill(chassisCol);
  chassis.stroke(color(40));
  chassis.strokeWeight(1);
  chassis.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  chassis.tag = "car" + ((idx) / partsPerCar);   // tag for picking
  parts[idx++] = chassis;
  
  // --- 2. Cabin ---
  Box cabin = new Box(130 * s, 45 * s, 80 * s);
  cabin.moveTo(ox - 10 * s, -47 * s, oz);
  cabin.fill(cabinCol);
  cabin.stroke(color(30));
  cabin.strokeWeight(1);
  cabin.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  cabin.tag = "car" + ((idx) / partsPerCar);
  parts[idx++] = cabin;
  
  // --- 3-6. Four wheels ---
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
    wheel.tag = "car" + ((idx) / partsPerCar);
    parts[idx++] = wheel;
  }
  
  // --- 7. Front lights bar ---
  Box lights = new Box(10 * s, 12 * s, 60 * s);
  lights.moveTo(ox - 115 * s, -5 * s, oz);
  lights.fill(color(255, 245, 180));
  lights.stroke(color(200, 180, 80));
  lights.strokeWeight(1);
  lights.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  lights.tag = "car" + ((idx) / partsPerCar);
  parts[idx++] = lights;
  
  return idx;
}

// Brighten a color by blending it toward white
color brighten(color c, float amt) {
  return lerpColor(c, color(255), amt);
}

// Apply current selection state: brighten the picked car, restore others
void applySelectionColors() {
  for (int c = 0; c < numCars; c++) {
    int base = c * partsPerCar;
    color chassisCol = chassisColors[c];
    color cabinCol   = cabinColors[c];
    
    if (c == selectedCar) {
      chassisCol = brighten(chassisCol, 0.55);
      cabinCol   = brighten(cabinCol,   0.55);
    }
    
    parts[base    ].fill(chassisCol);  // chassis
    parts[base + 1].fill(cabinCol);    // cabin
    // wheels (base+2 .. base+5) and lights (base+6) keep their original fills
  }
}

void mousePressed() {
  // Pick the topmost shape under the cursor
  Picked picked = Shape3D.pick(this, g, mouseX, mouseY);
  
  int newSelection = -1;
  
  if (picked != null && picked.shape != null) {
      Shape3D pickedShape = picked.shape;
  
      if (pickedShape.tag != null && pickedShape.tag.startsWith("car")) {
        newSelection = int(pickedShape.tag.substring(3));
      }
    }
  
  // If user clicked the same car again, deselect; otherwise switch
  if (newSelection == selectedCar) {
    selectedCar = -1;
  } else {
    selectedCar = newSelection;
  }
  
  applySelectionColors();
  
  if (selectedCar >= 0) {
    println("Picked car " + selectedCar);
  } else {
    println("No car selected");
  }
}
