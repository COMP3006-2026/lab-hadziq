/*
Add a simple camera into the scene in question 4 so that we can see it at different angles.
*/

import shapes3d.utils.*;
import shapes3d.*;

Ellipsoid sun, earth, moon, stars;
ShapeGroup earth_moon;
PImage sunImg, earthImg, moonImg, starsImg;

// Earth's orbital state (1/3 of original 800)
float earthOrbitAngle = 0;
float earthOrbitRadius = 267;

// Camera control
float angleX = -0.3;
float angleY = 0.4;

void setup() {
  size(1000, 1000, P3D);
  
  // --- Sun at origin (radius 300 -> 100) ---
  sun = new Ellipsoid(100, 50, 50);
  sunImg = loadImage("../exercise4/data/sun.jpg");
  sun.texture(sunImg);
  sun.moveTo(0, 0, 0);
  sun.drawMode(Shape3D.TEXTURE);
  
  // --- Earth (radius 150 -> 50) ---
  earth = new Ellipsoid(50, 50, 50);
  earthImg = loadImage("../exercise4/data/earth.jpg");
  earth.texture(earthImg);
  earth.drawMode(Shape3D.TEXTURE);
  
  // --- Moon (radii 50,30,30 -> 17,10,10; offset 250 -> 83) ---
  moon = new Ellipsoid(17, 10, 10);
  moonImg = loadImage("../exercise4/data/moon.jpg");
  moon.texture(moonImg);
  moon.moveTo(0, 0, 83);
  moon.drawMode(Shape3D.TEXTURE);
  
  // --- Star background (4000 -> 1333) ---
  stars = new Ellipsoid(1333, 50, 50);
  starsImg = loadImage("../exercise4/data/stars.jpg");
  stars.texture(starsImg);
  stars.drawMode(Shape3D.TEXTURE);
  
  // --- Group Earth + Moon ---
  earth_moon = new ShapeGroup();
  earth_moon.addChild(earth);
  earth_moon.addChild(moon);
}

void draw() {
  background(0);
  
  // --- Animate ---
  earthOrbitAngle += radians(0.5);
  float ex = cos(earthOrbitAngle) * earthOrbitRadius;
  float ez = sin(earthOrbitAngle) * earthOrbitRadius;
  earth.moveTo(ex, 0, ez);
  moon.moveTo(ex, 0, ez + 83);     // moon offset also 1/3
  
  earth_moon.rotateBy(0, radians(2.0), 0);
  sun.rotateBy(0, radians(0.2), 0);
  earth.rotateBy(0, radians(3.0), 0);
  stars.rotateBy(0, 0, radians(0.05));
  
  // --- Camera: translate to screen center, apply mouse-drag rotation ---
  translate(width/2, height/2, 0);
  if (mousePressed) {
    angleY = map(mouseX, 0, width, -PI, PI);
    angleX = map(mouseY, 0, height, -PI, PI);
  }
  rotateX(angleX);
  rotateY(angleY);
  
  // --- Pass 1: Earth & Moon lit by the Sun ---
  ambientLight(30, 30, 40);
  pointLight(255, 250, 230, 0, 0, 0);
  earth_moon.draw(g);
  
  // --- Pass 2: Sun, self-illuminated ---
  noLights();
  ambientLight(255, 255, 255);
  sun.draw(g);
  
  // --- Pass 3: Starfield ---
  noLights();
  ambientLight(200, 200, 200);
  stars.draw(g);
}
