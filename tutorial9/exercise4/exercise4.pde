/*
Use the external library shape3D and the example in lecture note 10 
to construct a complex scene with the Sun, the Earth and the Moon. 
The Sun is rotating by itself, while the Earth is orbiting 
around the Sun and the Moon is also orbiting around the Earth. 
Add texture to the Sun, the Earth and the Moon.
*/

import shapes3d.utils.*;
import shapes3d.*;

Ellipsoid sun, earth, moon, stars;
ShapeGroup earth_moon;
PImage sunImg, earthImg, moonImg, starsImg;

// Earth's orbital state
float earthOrbitAngle = 0;
float earthOrbitRadius = 267;

void setup() {
  size(1000, 1000, P3D);
  
  // --- Sun at origin ---
  sun = new Ellipsoid(100, 50, 50);
  sunImg = loadImage("data/sun.jpg");
  sun.texture(sunImg);
  sun.moveTo(0, 0, 0);
  sun.drawMode(Shape3D.TEXTURE);
  
  // --- Earth ---
  earth = new Ellipsoid(50, 50, 50);
  earthImg = loadImage("data/earth.jpg");
  earth.texture(earthImg);
  earth.moveTo(0, 0, 0);
  earth.drawMode(Shape3D.TEXTURE);
  
  // --- Moon ---
  moon = new Ellipsoid(17, 10, 10);
  moonImg = loadImage("data/moon.jpg");
  moon.texture(moonImg);
  moon.moveTo(0, 0, 83);
  moon.drawMode(Shape3D.TEXTURE);
  
  // --- Star background ---
  stars = new Ellipsoid(1333, 50, 50);
  starsImg = loadImage("data/stars.jpg");
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
  moon.moveTo(ex, 0, ez + 83);
  
  earth_moon.rotateBy(0, radians(2.0), 0);
  sun.rotateBy(0, radians(0.2), 0);
  earth.rotateBy(0, radians(3.0), 0);
  stars.rotateBy(0, 0, radians(0.05));
  
  // Center the scene on screen
  translate(width/2, height/2, 0);
  
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
