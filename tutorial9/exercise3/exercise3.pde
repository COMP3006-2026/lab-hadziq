/*
Use the external library shape3D to construct a “car-shape” object. 
The car object can be simply constructed 
by basic shapes such as boxes, ellipsoids, tubes, toroids, etc.
*/

import shapes3d.*;
import shapes3d.utils.*;

Shape3D[] parts;
float angleX = -0.3;
float angleY = 0.4;

void setup() {
  size(900, 650, P3D);
  buildCar();
}

void draw() {
  background(210, 220, 235);
  lights();
  
  // Ground plane
  pushMatrix();
  translate(width/2, height/2 + 60, 0);
  fill(120, 140, 110);
  noStroke();
  rotateX(HALF_PI);
  rectMode(CENTER);
  rect(0, 0, 1200, 800);
  popMatrix();
  
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

void buildCar() {
  parts = new Shape3D[7];
  int idx = 0;
  
  // --- 1. Chassis (lower body) -- Box ---
  Box chassis = new Box(220, 50, 90);
  chassis.moveTo(0, 0, 0);
  chassis.fill(color(200, 40, 50));
  chassis.stroke(color(40));
  chassis.strokeWeight(1);
  chassis.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = chassis;
  
  // --- 2. Cabin (upper body) -- smaller Box on top ---
  Box cabin = new Box(130, 45, 80);
  cabin.moveTo(-10, -47, 0);
  cabin.fill(color(60, 90, 160));
  cabin.stroke(color(30));
  cabin.strokeWeight(1);
  cabin.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = cabin;
  
  // --- 3-6. Four wheels -- Ellipsoid flattened on X axis ---
  // rx=8 (thin sideways), ry=22 (tall), rz=22 (wide) -> disc-shaped
  float wheelY = 30.0;
  float wheelXOffset = 75.0;
  float wheelZOffset = 50.0;
  
  float[][] wheelPos = {
    {-wheelXOffset, wheelY,  wheelZOffset},
    {-wheelXOffset, wheelY, -wheelZOffset},
    { wheelXOffset, wheelY,  wheelZOffset},
    { wheelXOffset, wheelY, -wheelZOffset}
  };
  
  for (int i = 0; i < 4; i++) {
    // rx=22, ry=22, rz=8 -> disc thin along Z (sideways axle)
    Ellipsoid wheel = new Ellipsoid(22.0, 22.0, 8.0, 16, 16);
    wheel.moveTo(wheelPos[i][0], wheelPos[i][1], wheelPos[i][2]);
    wheel.fill(color(30));
    wheel.stroke(color(160));
    wheel.strokeWeight(1);
    wheel.drawMode(Shape3D.SOLID | Shape3D.WIRE);
    parts[idx++] = wheel;
  }
  
  // --- 7. Front lights bar -- one Box spanning both headlight positions ---
  // (keeping it really simple: just one small box across the front)
  Box lights = new Box(10, 12, 60);
  lights.moveTo(-115, -5, 0);
  lights.fill(color(255, 245, 180));
  lights.stroke(color(200, 180, 80));
  lights.strokeWeight(1);
  lights.drawMode(Shape3D.SOLID | Shape3D.WIRE);
  parts[idx++] = lights;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    angleX = -0.3;
    angleY = 0.4;
  }
}
